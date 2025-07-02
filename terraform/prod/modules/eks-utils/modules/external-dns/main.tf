terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# OIDC Provider URL에서 호스트만 추출
locals {
  oidc_issuer_host = replace(var.cluster_oidc_issuer, "https://", "")
}

# External-DNS IAM Policy 생성
resource "aws_iam_policy" "external_dns" {
  name        = "${var.name}-external-dns-policy"
  description = "IAM policy for External-DNS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets"
        ]
        Resource = [
          "arn:aws:route53:::hostedzone/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets"
        ]
        Resource = [
          "*"
        ]
      }
    ]
  })

  tags = merge(var.default_tags, {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/managed-by"                  = "terraform"
  })
}

# External-DNS IAM Role 생성 (IRSA)
resource "aws_iam_role" "external_dns" {
  name = "${var.name}-external-dns-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_issuer_host}"
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${local.oidc_issuer_host}:sub" = "system:serviceaccount:kube-system:external-dns"
          "${local.oidc_issuer_host}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })

  tags = merge(var.default_tags, {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/managed-by"                  = "terraform"
  })
}

# Policy를 Role에 연결
resource "aws_iam_role_policy_attachment" "external_dns" {
  policy_arn = aws_iam_policy.external_dns.arn
  role       = aws_iam_role.external_dns.name
}

# Account ID 가져오기
data "aws_caller_identity" "current" {}

# Service Account 생성
resource "kubernetes_service_account" "external_dns" {
  metadata {
    name      = "external-dns"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.external_dns.arn
    }
    labels = {
      "app.kubernetes.io/name"       = "external-dns"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

# Helm Chart로 External-DNS 설치
resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  namespace  = "kube-system"
  version    = "1.15.0"

  values = [
    yamlencode({
      serviceAccount = {
        create = false
        name   = kubernetes_service_account.external_dns.metadata[0].name
      }
      provider = "aws"
      aws = {
        region = var.region
        zoneType = "public"
        preferCNAME = true
      }
      domainFilters = var.domain_filters
      policy = "sync"
      registry = "txt"
      txtOwnerId = var.cluster_name
      txtPrefix = "external-dns-${var.cluster_name}-"
      sources = [
        "service",
        "ingress"
      ]
      rbac = {
        create = true
      }
      securityContext = {
        fsGroup = 65534
      }
      metrics = {
        enabled = true
        serviceMonitor = {
          enabled = true
        }
      }
      extraArgs = [
        "--txt-wildcard-replacement=*"
      ]
      podAnnotations = {
        "cluster-autoscaler.kubernetes.io/safe-to-evict" = "true"
      }
      podLabels = {
        "app.kubernetes.io/name"       = "external-dns"
        "app.kubernetes.io/managed-by" = "terraform"
      }
    })
  ]

  depends_on = [
    kubernetes_service_account.external_dns,
    aws_iam_role_policy_attachment.external_dns
  ]
} 