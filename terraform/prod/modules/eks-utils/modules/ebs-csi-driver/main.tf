terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

###############################################
####           EBS CSI Driver IRSA         ####
###############################################

# EBS CSI Driver를 위한 IAM Role (IRSA)
resource "aws_iam_role" "ebs_csi_driver" {
  name = "${var.name}-ebs-csi-driver-role"

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
            "${replace(var.cluster_oidc_issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
            "${replace(var.cluster_oidc_issuer, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = var.default_tags
}

# EBS CSI Driver IAM 정책 연결
resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy" {
  role       = aws_iam_role.ebs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

###############################################
####        EBS CSI Driver Addon           ####
###############################################

# EBS CSI Driver Add-on
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = var.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = aws_iam_role.ebs_csi_driver.arn

  tags = merge(var.default_tags, {
    Name = "${var.name}-ebs-csi-driver-addon"
  })

  depends_on = [
    aws_iam_role_policy_attachment.ebs_csi_driver_policy
  ]
}

###############################################
####              Data Sources             ####
###############################################

# 현재 AWS 계정 ID 가져오기
data "aws_caller_identity" "current" {} 