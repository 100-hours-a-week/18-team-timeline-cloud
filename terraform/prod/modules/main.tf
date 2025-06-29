# Security Groups
module "sg" {
  source = "./sg"
  vpc_id = var.vpc_id
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

# EKS-UTILS
module "eks_utils" {
  source = "./eks-utils"
  providers = {
    kubernetes = kubernetes
    helm = helm
  }
  name = var.project
  vpc_id = var.vpc_id
  public_subnet_id = var.public_subnet_a_id
  cluster_name = module.eks.cluster_name
  cluster_oidc_issuer = module.eks.cluster_oidc_issuer
  region = "ap-northeast-2"
  key_name = var.key_pair_name
  bastion_instance_type = "t3.medium"
  enable_bastion = true
  enable_alb_controller = true
  enable_argocd = var.enable_argocd
  argocd_chart_version = var.argocd_chart_version
  node_iam_role_arns = [for ng in module.eks.node_groups : ng.node_group_iam_role_arn]
  default_tags = {
    Project = var.project
    Environment = var.environment
  }
  depends_on = [module.eks]
}

# RDS
module "rds" {
  source = "./rds"

  vpc_id               = var.vpc_id
  private_subnet_a_db_id = var.private_subnet_a_db_id
  private_subnet_c_db_id = var.private_subnet_c_db_id

  backend_sg_id        = module.sg.backend_sg_id

  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage

  project              = var.project
  environment          = var.environment
}