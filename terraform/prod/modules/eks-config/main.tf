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
  }
}

# Unified IRSA (Frontend + Backend + Namespace)
module "irsa" {
  source = "./modules/irsa"
  
  providers = {
    kubernetes = kubernetes
  }

  name                = var.name
  cluster_oidc_issuer = var.cluster_oidc_issuer
  default_tags        = var.default_tags
  
  # Namespace settings
  create_namespace = true
  app_namespace    = var.frontend_namespace
  backend_namespace = var.k8s_namespace
  
  # Frontend IRSA settings
  enable_frontend_irsa           = var.enable_frontend_irsa
  frontend_service_account_name  = var.frontend_service_account_name
  frontend_s3_bucket_name        = var.frontend_s3_bucket_name
  
  # Backend IRSA settings  
  enable_backend_irsa           = true
  backend_service_account_name  = "backend-service-account"
}

# ============================================================================
# Secrets (Parameter Store → Kubernetes Secret)
# ============================================================================
module "secrets" {
  source = "./modules/secrets"
  
  count = var.enable_secrets ? 1 : 0
  
  providers = {
    aws        = aws
    kubernetes = kubernetes
  }
  
  namespace = module.irsa.app_namespace
} 