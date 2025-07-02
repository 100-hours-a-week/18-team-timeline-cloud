terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

resource "aws_iam_role" "backend_role" {
  name = "${var.project}-${var.environment}-backend-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Condition = {
          StringEquals = {
            "${var.oidc_provider}:sub" = "system:serviceaccount:${var.k8s_namespace}:backend-service-account"
            "${var.oidc_provider}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

resource "kubernetes_service_account" "backend" {
  metadata {
    name      = "backend-service-account"
    namespace = var.k8s_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.backend_role.arn
    }
  }
}

# 필요한 정책 첨부
resource "aws_iam_role_policy_attachment" "backend_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"  # 예시로 S3 읽기 권한을 추가
  role       = aws_iam_role.backend_role.name
} 