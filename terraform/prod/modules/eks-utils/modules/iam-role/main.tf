# Backend Service Account IAM Role
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
            "${var.oidc_provider}:sub": "system:serviceaccount:${var.namespace}:backend-service-account",
            "${var.oidc_provider}:aud": "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = {
    Name = "${var.project}-${var.environment}-backend-role"
  }
}

# Backend Service Account IAM Policy
resource "aws_iam_role_policy" "backend_policy" {
  name = "${var.project}-${var.environment}-backend-policy"
  role = aws_iam_role.backend_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [
          "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:${var.project}/${var.environment}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.project}-environment/*"  # 환경설정 파일이 있는 S3 버킷
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.project}-environment"  # 버킷 자체에 대한 접근 권한
        ]
      }
    ]
  })
} 