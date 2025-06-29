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
  public_subnet_ids = [var.public_subnet_a_id, var.public_subnet_c_id]
  kubernetes_version = "1.33"
  region = "ap-northeast-2"
  key_name = var.key_pair_name
  
  tags = {
    Project = var.project
    Environment = var.environment
  }
  
  enable_bastion = true
  
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
      ami_type = "AL2_x86_64"
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
      ami_type = "AL2_x86_64"
    }
  ]
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