resource "aws_eks_addon" "adot" {
  count = var.enable_adot ? 1 : 0

  cluster_name                = var.cluster_name
  addon_name                 = "adot"
  # 버전을 명시하지 않으면 AWS가 호환 버전을 자동 선택
  service_account_role_arn  = aws_iam_role.adot[0].arn
  preserve                  = true

  tags = merge(
    var.default_tags,
    {
      Name = "${var.name}-adot-addon"
    }
  )
}

# Data source for OIDC provider
data "aws_eks_cluster" "cluster" {
  count = var.enable_adot ? 1 : 0
  name  = var.cluster_name
}

data "aws_iam_openid_connect_provider" "cluster" {
  count = var.enable_adot ? 1 : 0
  url   = data.aws_eks_cluster.cluster[0].identity[0].oidc[0].issuer
}

# ADOT IAM Role for Service Account (IRSA)
resource "aws_iam_role" "adot" {
  count = var.enable_adot ? 1 : 0

  name = "${var.name}-adot-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.cluster[0].arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(data.aws_iam_openid_connect_provider.cluster[0].url, "https://", "")}:sub" = "system:serviceaccount:opentelemetry-operator-system:adot-collector"
            "${replace(data.aws_iam_openid_connect_provider.cluster[0].url, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = merge(
    var.default_tags,
    {
      Name = "${var.name}-adot-role"
    }
  )
}

# ADOT IAM Policy
resource "aws_iam_role_policy_attachment" "adot_policy" {
  count = var.enable_adot ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
  role       = aws_iam_role.adot[0].name
}

resource "aws_iam_role_policy_attachment" "cloudwatch_policy" {
  count = var.enable_adot ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.adot[0].name
}

resource "aws_iam_role_policy_attachment" "amp_policy" {
  count = var.enable_adot ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonPrometheusRemoteWriteAccess"
  role       = aws_iam_role.adot[0].name
} 