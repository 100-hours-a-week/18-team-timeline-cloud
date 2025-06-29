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

# Bastion Host
module "bastion" {
  source = "./modules/bastion"

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
  source = "./modules/aws_auth"
  providers = {
    kubernetes = kubernetes
  }

  cluster_name = var.cluster_name
  node_iam_role_arns = var.node_iam_role_arns
  additional_role_arns = var.enable_bastion ? [module.bastion[0].bastion_iam_role_arn] : []
  default_tags = var.default_tags
  
  depends_on = [module.bastion]
}

# AWS Load Balancer Controller
module "alb_controller" {
  source = "./modules/alb-controller"
  
  count = var.enable_alb_controller ? 1 : 0
  
  providers = {
    kubernetes = kubernetes
    helm = helm
  }

  name = var.name
  cluster_name = var.cluster_name
  cluster_oidc_issuer = var.cluster_oidc_issuer
  vpc_id = var.vpc_id
  region = var.region
  default_tags = var.default_tags
  
  depends_on = [module.aws_auth]
} 