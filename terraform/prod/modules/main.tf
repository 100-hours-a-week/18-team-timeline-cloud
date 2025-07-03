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

# Security Groups
module "sg" {
  source = "./sg"
  vpc_id = var.vpc_id
  vpc_cidr = var.vpc_cidr_block
  project = var.project
  environment = var.environment
}

# OpenVPN
module "openvpn" {
  source = "./openvpn"

  name = var.project
  instance_type = var.instance_type
  public_subnet_id = var.public_subnet_a_id
  sg_openvpn_id = module.sg.openvpn_sg_id
  key_pair_name = var.key_pair_name
  eip_allocation_id = var.openvpn_eip_allocation_id
  default_tags = {
    Project = var.project
    Environment = var.environment
  }
}

# EKS
module "eks" {
  source = "./eks"

  name = var.project
  vpc_id = var.vpc_id
  vpc_cidr = var.vpc_cidr_block
  project = var.project
  environment = var.environment
  kubernetes_version = "1.33"
  region = "ap-northeast-2"
  
  tags = {
    Project = var.project
    Environment = var.environment
  }
  
  # 프론트엔드용 노드 그룹
  node_groups = [
    {
      name = "frontend"
      subnet_ids = [var.private_subnet_a_front_id, var.private_subnet_c_front_id]
      instance_types = ["t3.small"]
      disk_size = 20
      desired_size = 2
      max_size = 4
      min_size = 1
      capacity_type = "ON_DEMAND"
      ami_type = "AL2023_x86_64_STANDARD"
    },
    # 백엔드용 노드 그룹
    {
      name = "backend"
      subnet_ids = [var.private_subnet_a_back_id, var.private_subnet_c_back_id]
      instance_types = ["t3.medium"]
      disk_size = 30
      desired_size = 2
      max_size = 6
      min_size = 1
      capacity_type = "ON_DEMAND"
      ami_type = "AL2023_x86_64_STANDARD"
    }
  ]
}

# EKS 클러스터 outputs로 provider "kubernetes" 선언
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

# ============================================================================
# EKS UTILITIES & ADD-ONS
# ============================================================================
# EKS 클러스터에 필요한 모든 유틸리티와 애드온을 설치하는 모듈
# - Bastion Host (kubectl 접근용)
# - ALB Controller (Ingress 처리)  
# - External-DNS (Route53 자동 DNS 관리)
# - ArgoCD (GitOps CD 도구)
# ============================================================================

module "eks_utils" {
  source = "./eks-utils"
  
  # Provider 설정
  providers = {
    aws        = aws
    kubernetes = kubernetes
    helm       = helm
  }

  # 기본 설정
  name                = var.project
  project             = var.project
  environment         = var.environment
  region              = "ap-northeast-2"
  vpc_id              = var.vpc_id
  vpc_cidr            = var.vpc_cidr_block
  public_subnet_id    = var.public_subnet_a_id
  cluster_name        = module.eks.cluster_name
  cluster_oidc_issuer = module.eks.cluster_oidc_issuer
  node_iam_role_arns  = [for ng in module.eks.node_groups : ng.node_group_iam_role_arn]

  # Bastion Host 설정 (SSH 접근용)
  enable_bastion          = true
  key_name                = var.key_pair_name
  bastion_instance_type   = "t3.medium"

  # ALB Controller 설정 (Ingress 처리)
  enable_alb_controller   = true

  # EBS CSI Driver 설정 (Redis PVC 문제 해결)
  enable_ebs_csi_driver   = true

  # External-DNS 설정 
  enable_external_dns     = var.enable_external_dns     # tam-nara.com 도메인 자동 관리
  domain_filters          = var.domain_filters          # ["tam-nara.com"]

  # ArgoCD 설정 
  enable_argocd           = var.enable_argocd           # ArgoCD 설치 여부
  argocd_safe_destroy     = var.argocd_safe_destroy     # 안전한 삭제 모드
  argocd_chart_version    = var.argocd_chart_version    # ArgoCD Helm Chart 버전
  
  # App of Apps 패턴 설정 (ArgoCD 애플리케이션 자동 배포)
  enable_app_of_apps      = var.enable_app_of_apps      # App of Apps 활성화
  repo_url                = var.repo_url                # Git 저장소 URL
  target_revision         = var.target_revision         # Git 브랜치/태그
  applications_path       = var.applications_path       # 애플리케이션 manifest 경로

  # 공통 태그
  default_tags = {
    Project     = var.project
    Environment = var.environment
  }

  depends_on = [module.eks]
}

# ============================================================================
# EKS CONFIG (Application Configuration)
# ============================================================================
# EKS 애플리케이션 설정을 담당하는 모듈
# - IRSA (Frontend + Backend Service Account & IAM Role)
# - Secrets (Parameter Store → Kubernetes Secret)
# ============================================================================

module "eks_config" {
  source = "./eks-config"
  
  # Provider 설정
  providers = {
    aws        = aws
    kubernetes = kubernetes
  }

  # 기본 설정
  name                = var.project
  cluster_oidc_issuer = module.eks.cluster_oidc_issuer
  
  # Secrets 설정 (Parameter Store → Kubernetes Secret)
  enable_secrets = true

  # Frontend IRSA 설정
  enable_frontend_irsa           = var.enable_frontend_irsa
  frontend_namespace             = var.frontend_namespace
  frontend_service_account_name  = var.frontend_service_account_name
  frontend_s3_bucket_name        = var.frontend_s3_bucket_name
  
  # Backend IRSA 설정
  k8s_namespace                  = var.k8s_namespace

  # 공통 태그
  default_tags = {
    Project     = var.project
    Environment = var.environment
  }

  depends_on = [module.eks_utils]
}

# RDS
module "rds" {
  source = "./rds"

  vpc_id               = var.vpc_id
  private_subnet_a_db_id = var.private_subnet_a_db_id
  private_subnet_c_db_id = var.private_subnet_c_db_id

  backend_sg_id        = module.sg.backend_sg_id
  eks_cluster_sg_id    = module.eks.cluster_default_security_group_id  # EKS 자동 생성 보안 그룹 (Node Groups가 실제 사용)

  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  db_snapshot_identifier = var.db_snapshot_identifier

  project              = var.project
  environment          = var.environment
}