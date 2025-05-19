provider "aws" {
  region  = "ap-northeast-2"
  profile = "default"
}

# VPC
module "vpc" {
  source             = "./modules/vpc"
  cidr_block         = var.vpc_cidr_block
  public_subnet_a_id = module.subnet.public_subnet_a_id
  public_subnet_c_id = module.subnet.public_subnet_c_id
}

# Subnet
module "subnet" {
  source                 = "./modules/subnet"
  vpc_id                 = module.vpc.vpc_id
  az_a                   = var.az_a
  az_c                   = var.az_c
  public_subnet_a_cidr   = var.public_subnet_a_cidr
  public_subnet_c_cidr   = var.public_subnet_c_cidr
  private_subnet_a_cidr  = var.private_subnet_a_cidr
  private_subnet_c_cidr  = var.private_subnet_c_cidr
}

# NAT + Private RT
module "nat_gateway" {
  source              = "./modules/nat_gateway"
  vpc_id              = module.vpc.vpc_id
  public_subnet_a_id  = module.subnet.public_subnet_a_id
  private_subnet_a_id = module.subnet.private_subnet_a_id
  private_subnet_c_id = module.subnet.private_subnet_c_id
}

# Security Group
module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

# Frontend ALB
module "alb_frontend" {
  source               = "./modules/alb/alb_frontend"
  vpc_id               = module.vpc.vpc_id

  public_subnet_ids    = [module.subnet.public_subnet_a_id, module.subnet.public_subnet_c_id]  # ✅ 누락1
  sg_alb_frontend_id = module.sg.sg_alb_frontend_id  # ✅ 변경                                                  # ✅ 누락2

  frontend_instance_map = {
    frontend-a = module.ec2.frontend_a_instance_id                                              # ✅ 누락3
    frontend-c = module.ec2.frontend_c_instance_id
  }
}


# Backend ALB
module "alb_backend" {
  source               = "./modules/alb/alb_backend"
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = [module.subnet.private_subnet_a_id, module.subnet.private_subnet_c_id]
  sg_alb_backend_id = module.sg.sg_alb_backend_id     # ✅ 변경

  backend_instance_map = {
    backend-a = module.ec2.backend_a_instance_id
    backend-c = module.ec2.backend_c_instance_id
  }
}
# EC2
module "ec2" {
  source = "./modules/ec2"

  ami_id               = var.ami_id
  instance_type        = var.instance_type
  private_subnet_a_id  = module.subnet.private_subnet_a_id
  private_subnet_c_id  = module.subnet.private_subnet_c_id
  sg_frontend_id       = module.sg.frontend_sg_id
  sg_backend_id        = module.sg.backend_sg_id
  tg_frontend_arn      = module.alb_frontend.frontend_target_group_arn
  tg_backend_arn       = module.alb_backend.backend_target_group_arn

  project              = var.project
  environment          = var.environment
}

module "rds" {
  source = "./modules/rds"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = [module.subnet.private_subnet_a_id, module.subnet.private_subnet_c_id]
  backend_sg_id      = module.sg.backend_sg_id

  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage

  project     = var.project
  environment = var.environment
}
