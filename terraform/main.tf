provider "aws" {
  region  = "ap-northeast-2"
  profile = "default"
}

terraform {
  backend "s3" {
    bucket         = "ktb18-terraform-state-bucket"
    key            = "global/s3/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}

# 공유 리소스 - VPC / Subnet
module "vpc" {
  source             = "./share/modules/vpc"
  cidr_block         = var.vpc_cidr_block
  public_subnet_a_id = module.subnet.public_subnet_a_id
  public_subnet_c_id = module.subnet.public_subnet_c_id
}

module "subnet" {
  source = "./share/modules/subnet"

  vpc_id = module.vpc.vpc_id
  az_a   = var.az_a
  az_c   = var.az_c

  public_subnet_a_cidr = var.public_subnet_a_cidr
  public_subnet_c_cidr = var.public_subnet_c_cidr

  private_subnet_a_front_cidr = var.private_subnet_a_front_cidr
  private_subnet_c_front_cidr = var.private_subnet_c_front_cidr

  private_subnet_a_back_cidr = var.private_subnet_a_back_cidr
  private_subnet_c_back_cidr = var.private_subnet_c_back_cidr

  private_subnet_a_db_cidr = var.private_subnet_a_db_cidr
  private_subnet_c_db_cidr = var.private_subnet_c_db_cidr
}

# NAT + Private RT
module "nat_gateway" {
  source = "./share/modules/nat_gateway"

  vpc_id             = module.vpc.vpc_id
  public_subnet_a_id = module.subnet.public_subnet_a_id

  private_subnet_a_front_id = module.subnet.private_subnet_a_front_id
  private_subnet_c_front_id = module.subnet.private_subnet_c_front_id
  private_subnet_a_back_id  = module.subnet.private_subnet_a_back_id
  private_subnet_c_back_id  = module.subnet.private_subnet_c_back_id
  private_subnet_a_db_id    = module.subnet.private_subnet_a_db_id
  private_subnet_c_db_id    = module.subnet.private_subnet_c_db_id
}

# Security Groups
module "sg" {
  source = "./prod/modules/sg"
  vpc_id = module.vpc.vpc_id
}

# EC2
module "ec2" {
  source = "./prod/modules/ec2"

  ami_id           = var.ami_id
  instance_type    = var.instance_type
  instance_type_be = var.instance_type_be
  key_pair_name    = var.key_pair_name

  public_subnet_a_id = module.subnet.public_subnet_a_id
  public_subnet_c_id = module.subnet.public_subnet_c_id

  private_subnet_a_front_id = module.subnet.private_subnet_a_front_id
  private_subnet_c_front_id = module.subnet.private_subnet_c_front_id
  private_subnet_a_back_id  = module.subnet.private_subnet_a_back_id
  private_subnet_c_back_id  = module.subnet.private_subnet_c_back_id

  sg_frontend_id = module.sg.frontend_sg_id
  sg_backend_id  = module.sg.backend_sg_id
  sg_openvpn_id  = module.sg.openvpn_sg_id

  project     = var.project
  environment = var.environment
}

# dev 환경 보안 그룹
module "dev_sg" {
  source = "./dev/modules/sg"
  vpc_id = module.vpc.vpc_id
}

# EC2
module "dev_ec2" {
  source = "./dev/modules/ec2"

  ami_id           = var.ami_id
  instance_type    = var.instance_type
  instance_type_be = var.instance_type_be
  key_pair_name    = var.key_pair_name

  public_subnet_a_id = module.subnet.public_subnet_a_id

  private_subnet_a_front_id = module.subnet.private_subnet_a_front_id
  private_subnet_a_back_id  = module.subnet.private_subnet_a_back_id
  private_subnet_a_db_id = module.subnet.private_subnet_a_db_id


  sg_frontend_id = module.dev_sg.sg_frontend_id
  sg_backend_id  = module.dev_sg.sg_backend_id
  sg_reverse_proxy_id = module.dev_sg.sg_reverse_proxy_id
  sg_db_id = module.dev_sg.sg_db_id

  project     = var.project
  environment = var.environment
}


# ALB Frontend
module "alb_frontend" {
  source             = "./prod/modules/alb/alb_frontend"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = [module.subnet.public_subnet_a_id, module.subnet.public_subnet_c_id]
  sg_alb_frontend_id = module.sg.sg_alb_frontend_id

  frontend_instance_map = {
    frontend-a = module.ec2.frontend_a_instance_id
    frontend-c = module.ec2.frontend_c_instance_id
  }
}

# ALB Backend
module "alb_backend" {
  source             = "./prod/modules/alb/alb_backend"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = [module.subnet.private_subnet_a_back_id, module.subnet.private_subnet_c_back_id]
  sg_alb_backend_id  = module.sg.sg_alb_backend_id

  backend_instance_map = {
    backend-a = module.ec2.backend_a_instance_id
    backend-c = module.ec2.backend_c_instance_id
  }
}

# ECS - Backend
module "ecs_backend" {
  source              = "./prod/modules/ecs"
  ecs_cluster_name    = "docker-v1-backend-cluster"
  container_name      = "docker-v1-backend"
  container_image     = "346011888304.dkr.ecr.ap-northeast-2.amazonaws.com/tamnara/be:latest"
  container_port      = 8080
  desired_count       = 2
  ecs_task_cpu        = "768"
  ecs_task_memory     = "1536"
  subnet_ids          = [module.subnet.private_subnet_a_back_id, module.subnet.private_subnet_c_back_id]
  security_group_ids  = [module.sg.backend_sg_id]
  target_group_arn    = module.alb_backend.backend_target_group_arn
}

# ECS - Frontend
module "ecs_frontend" {
  source              = "./prod/modules/ecs"
  ecs_cluster_name    = "docker-v1-frontend-cluster"
  container_name      = "docker-v1-frontend"
  container_image     = "346011888304.dkr.ecr.ap-northeast-2.amazonaws.com/tamnara/fe:latest"
  container_port      = 80
  desired_count       = 2
  ecs_task_cpu        = "256"
  ecs_task_memory     = "256"
  subnet_ids          = [module.subnet.private_subnet_a_front_id, module.subnet.private_subnet_c_front_id]
  security_group_ids  = [module.sg.frontend_sg_id]
  target_group_arn    = module.alb_frontend.frontend_target_group_arn
}

# RDS
module "rds" {
  source = "./prod/modules/rds"

  vpc_id               = module.vpc.vpc_id
  private_subnet_a_db_id = module.subnet.private_subnet_a_db_id
  private_subnet_c_db_id = module.subnet.private_subnet_c_db_id

  backend_sg_id        = module.sg.backend_sg_id

  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage

  project              = var.project
  environment          = var.environment
}

# Route53
module "route53" {
  source = "./prod/modules/route53"

  hosted_zone_id = var.dns_zone_id
  domain_name    = var.domain_name

  frontend_zone_id    = module.alb_frontend.zone_id
  frontend_dns_name   = module.alb_frontend.frontend_alb_dns_name
  backend_zone_id     = module.alb_backend.zone_id
  backend_dns_name    = module.alb_backend.backend_alb_dns_name
}
