# Frontend IRSA IAM Role
resource "aws_iam_role" "frontend_irsa" {
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
            "${replace(var.cluster_oidc_issuer, "https://", "")}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
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
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}"
        ]
      }
    ]
  })

  tags = var.default_tags
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "frontend_s3_access" {
  role       = aws_iam_role.frontend_irsa.name
  policy_arn = aws_iam_policy.frontend_s3_access.arn
}

# Data source for account ID
data "aws_caller_identity" "current" {}

# Kubernetes Service Account
resource "kubernetes_service_account" "frontend" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace
    
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.frontend_irsa.arn
    }
    
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
} 