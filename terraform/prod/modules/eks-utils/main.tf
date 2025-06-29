terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

# Bastion Host
module "bastion" {
  source = "../eks/modules/bastion"

  count = var.enable_bastion ? 1 : 0

  name = var.name
  vpc_id = var.vpc_id
  subnet_id = var.public_subnet_id
  cluster_name = var.cluster_name
  region = var.region
  key_name = var.key_name
  instance_type = var.bastion_instance_type
  default_tags = var.default_tags
}

# aws-auth ConfigMap
module "aws_auth" {
  source = "../eks/modules/aws_auth"
  providers = {
    kubernetes = kubernetes
  }

  cluster_name = var.cluster_name
  eks_cluster_endpoint = var.cluster_endpoint
  eks_cluster_ca = var.cluster_ca
  node_iam_role_arns = var.node_iam_role_arns
  additional_role_arns = var.enable_bastion ? [module.bastion[0].bastion_iam_role_arn] : []
  default_tags = var.default_tags
} 