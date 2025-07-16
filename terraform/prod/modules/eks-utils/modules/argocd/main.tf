terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}

# ArgoCD Namespace
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
    labels = {
      name = "argocd"
    }
  }
}

# ArgoCD Helm Release
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.51.4"  # ArgoCD 2.13.1 - stable version
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  wait                        = true      # 설치 완료까지 대기
  timeout                     = 600      # 10분 timeout
  cleanup_on_fail            = true      # 실패 시 정리
  force_update               = true      # 강제 업데이트
  recreate_pods              = false     # Pod 재생성 방지
  disable_webhooks           = true      # webhook 검증 무시
  disable_openapi_validation = true      # OpenAPI 검증 무시

  values = [
    yamlencode({
      server = {
        service = {
          type = "LoadBalancer"
          annotations = {
            "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
            "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
          }
        }
        config = {
          "application.instanceLabelKey" = "argocd.argoproj.io/instance"
          "server.insecure" = true  # HTTPS termination at LoadBalancer
        }
        extraArgs = [
          "--insecure"
        ]
      }
      controller = {
        metrics = {
          enabled = true
        }
      }
      repoServer = {
        metrics = {
          enabled = true
        }
      }
      configs = {
        params = {
          "server.insecure" = true
        }
      }
    })
  ]

  depends_on = [kubernetes_namespace.argocd]
}

# Data source to get ArgoCD server service
data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }
  depends_on = [helm_release.argocd]
}

# Data source to get initial admin secret
data "kubernetes_secret" "argocd_initial_admin_secret" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }
  depends_on = [helm_release.argocd]
}

# App of Apps - Root Application 자동 배포
resource "kubernetes_manifest" "app_of_apps" {
  count = var.enable_app_of_apps ? 1 : 0
  
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "app-of-apps"
      namespace = kubernetes_namespace.argocd.metadata[0].name
      labels = {
        "app.kubernetes.io/name" = "app-of-apps"
      }
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.repo_url
        targetRevision = var.target_revision
        path           = var.applications_path
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = kubernetes_namespace.argocd.metadata[0].name
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = [
          "CreateNamespace=true"
        ]
      }
    }
  }
  
  depends_on = [helm_release.argocd]
}

# 기존 EKS 클러스터 정보 참조
data "aws_eks_cluster" "existing" {
  name = var.cluster_name
}

# 기존 OIDC provider 정보 참조
data "aws_iam_openid_connect_provider" "existing" {
  url = data.aws_eks_cluster.existing.identity[0].oidc[0].issuer
}

# ArgoCD Image Updater용 ECR 접근 IAM Role
resource "aws_iam_role" "argocd_image_updater_ecr" {
  name = "${var.cluster_name}-argocd-image-updater-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.existing.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(data.aws_iam_openid_connect_provider.existing.url, "https://", "")}:sub" = "system:serviceaccount:argocd:argocd-image-updater"
            "${replace(data.aws_iam_openid_connect_provider.existing.url, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  inline_policy {
    name = "ECRAccess"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetRepositoryPolicy",
            "ecr:DescribeRepositories",
            "ecr:ListImages",
            "ecr:DescribeImages",
            "ecr:BatchGetImage"
          ]
          Resource = "*"
        }
      ]
    })
  }
} 