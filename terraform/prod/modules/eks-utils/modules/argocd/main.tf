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