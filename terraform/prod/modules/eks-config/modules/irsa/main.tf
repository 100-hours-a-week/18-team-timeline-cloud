terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

# Data source for account ID
data "aws_caller_identity" "current" {}

# ============================================================================
# NAMESPACE CREATION
# ============================================================================
# Create the namespace for frontend and backend services
resource "kubernetes_namespace" "app_namespace" {
  count = var.create_namespace ? 1 : 0
  
  metadata {
    name = var.app_namespace
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "app.kubernetes.io/name" = "application-namespace"
    }
  }
}

# ============================================================================
# FRONTEND IRSA
# ============================================================================
# Frontend IRSA IAM Role
resource "aws_iam_role" "frontend_irsa" {
  count = var.enable_frontend_irsa ? 1 : 0
  name = "${var.name}-frontend-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(var.cluster_oidc_issuer, "https://", "")}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(var.cluster_oidc_issuer, "https://", "")}:sub" = "system:serviceaccount:${var.app_namespace}:${var.frontend_service_account_name}"
            "${replace(var.cluster_oidc_issuer, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = var.default_tags
}

# S3 access policy for frontend
resource "aws_iam_policy" "frontend_s3_access" {
  count = var.enable_frontend_irsa ? 1 : 0
  name        = "${var.name}-frontend-s3-access-irsa"
  description = "Allow frontend pods to access S3 environment files"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.frontend_s3_bucket_name}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.frontend_s3_bucket_name}"
        ]
      }
    ]
  })

  tags = var.default_tags
}

# Attach policy to frontend role
resource "aws_iam_role_policy_attachment" "frontend_s3_access" {
  count = var.enable_frontend_irsa ? 1 : 0
  role       = aws_iam_role.frontend_irsa[0].name
  policy_arn = aws_iam_policy.frontend_s3_access[0].arn
}

# Frontend Kubernetes Service Account
resource "kubernetes_service_account" "frontend" {
  count = var.enable_frontend_irsa ? 1 : 0
  
  metadata {
    name      = var.frontend_service_account_name
    namespace = var.app_namespace
    
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.frontend_irsa[0].arn
    }
    
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
  
  depends_on = [kubernetes_namespace.app_namespace]
}

# ============================================================================
# BACKEND IRSA
# ============================================================================
# Backend IRSA IAM Role
resource "aws_iam_role" "backend_irsa" {
  count = var.enable_backend_irsa ? 1 : 0
  name = "${var.name}-backend-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(var.cluster_oidc_issuer, "https://", "")}"
        }
        Condition = {
          StringEquals = {
            "${replace(var.cluster_oidc_issuer, "https://", "")}:sub" = "system:serviceaccount:${var.app_namespace}:${var.backend_service_account_name}"
            "${replace(var.cluster_oidc_issuer, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = var.default_tags
}

# Backend Kubernetes Service Account
resource "kubernetes_service_account" "backend" {
  count = var.enable_backend_irsa ? 1 : 0
  
  metadata {
    name      = var.backend_service_account_name
    namespace = var.app_namespace
    
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.backend_irsa[0].arn
    }
    
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
  
  depends_on = [kubernetes_namespace.app_namespace]
}

# Backend S3 read-only access
resource "aws_iam_role_policy_attachment" "backend_s3_policy" {
  count = var.enable_backend_irsa ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.backend_irsa[0].name
} 