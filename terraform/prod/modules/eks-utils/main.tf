terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

# Bastion Host
module "bastion" {
  source = "./modules/bastion"

  count = var.enable_bastion ? 1 : 0

  name = var.name
  vpc_id = var.vpc_id
  vpc_cidr = var.vpc_cidr
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

# External-DNS
module "external_dns" {
  source = "./modules/external-dns"
  
  count = var.enable_external_dns ? 1 : 0
  
  providers = {
    kubernetes = kubernetes
    helm = helm
  }

  name = var.name
  cluster_name = var.cluster_name
  cluster_oidc_issuer = var.cluster_oidc_issuer
  region = var.region
  domain_filters = var.domain_filters
  default_tags = var.default_tags
  
  depends_on = [module.aws_auth, module.alb_controller]
}



# EBS CSI Driver (Redis PVC 문제 해결을 위한 필수 addon)
module "ebs_csi_driver" {
  source = "./modules/ebs-csi-driver"
  
  count = var.enable_ebs_csi_driver ? 1 : 0

  name                = var.name
  cluster_name        = var.cluster_name
  cluster_oidc_issuer = var.cluster_oidc_issuer
  region              = var.region
  default_tags        = var.default_tags
  
  depends_on = [module.aws_auth]
}

# ArgoCD
module "argocd" {
  source = "./modules/argocd"
  
  count = var.enable_argocd && !var.argocd_safe_destroy ? 1 : 0
  
  providers = {
    kubernetes = kubernetes
    helm = helm
  }

  argocd_chart_version = var.argocd_chart_version
  enable_app_of_apps = var.enable_app_of_apps
  repo_url = var.repo_url
  target_revision = var.target_revision
  applications_path = var.applications_path
  
  depends_on = [module.aws_auth, module.alb_controller, module.external_dns, module.ebs_csi_driver]
}





# ============================================================================
# Data Sources
# ============================================================================
data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_iam_openid_connect_provider" "this" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

locals {
  oidc_provider     = replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")
  oidc_provider_arn = data.aws_iam_openid_connect_provider.this.arn
} 