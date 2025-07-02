terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
}

###############################################
####               IAM Role                ####
###############################################

resource "aws_iam_role" "this" {
    name = "${var.name}-eks-cluster-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = {
                Service = "eks.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        }]
    })

    tags = var.default_tags
}

resource "aws_iam_role_policy_attachment" "cluster_policy_attachment"{
    for_each = toset([
        "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
        "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
        "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
    ])
    role = aws_iam_role.this.name
    policy_arn = each.value
}

###############################################
####            Security Group             ####
###############################################

resource "aws_security_group" "cluster" {
  name        = "${var.project}-${var.environment}-cluster-sg"
  description = "EKS cluster security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow internal VPC traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name = "${var.project}-${var.environment}-cluster-sg"
  }
}

###############################################
####              EKS Cluster              ####
###############################################

resource "aws_eks_cluster" "this" {
    name = "${var.name}-cluster"
    version = var.kubernetes_version
    role_arn = aws_iam_role.this.arn
    enabled_cluster_log_types = var.cluster_enabled_log_types

    vpc_config {
        security_group_ids = [aws_security_group.cluster.id]
        subnet_ids = var.private_subnet_ids
        endpoint_private_access = true
        endpoint_public_access = true
        public_access_cidrs = ["0.0.0.0/0"]  # 임시로 모든 IP 허용, 나중에 제한
    }

    access_config {
        authentication_mode = "API_AND_CONFIG_MAP"
        bootstrap_cluster_creator_admin_permissions = true
    }

    tags = var.default_tags
}

###############################################
####         OIDC Identity Provider        ####
###############################################

# EKS 클러스터 OIDC issuer의 TLS 인증서 정보 가져오기
data "tls_certificate" "this" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# OIDC Identity Provider 생성 (IRSA 사용을 위해 필요)
resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer

  tags = merge(var.default_tags, {
    Name = "${var.name}-eks-oidc-provider"
  })
}