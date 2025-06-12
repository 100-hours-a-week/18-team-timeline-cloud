provider "aws" {
  region  = "ap-northeast-2"
  profile = "default"
}

terraform {
  backend "s3" {
    bucket         = "ktb18-terraform-state-bucket"
    key            = "global/s3/terraform.tfstate" # 경로 형식
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
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

  // 프론트 서브넷 CIDR
  private_subnet_a_front_cidr  = var.private_subnet_a_front_cidr
  private_subnet_c_front_cidr  = var.private_subnet_c_front_cidr

  // 백엔드 서브넷 CIDR
  private_subnet_a_back_cidr  = var.private_subnet_a_back_cidr
  private_subnet_c_back_cidr  = var.private_subnet_c_back_cidr

  # DB 서브넷 CIDR
  private_subnet_a_db_cidr  = var.private_subnet_a_db_cidr
  private_subnet_c_db_cidr  = var.private_subnet_c_db_cidr
}

# NAT + Private RT
module "nat_gateway" {
  
  source              = "./modules/nat_gateway"
  vpc_id              = module.vpc.vpc_id
  public_subnet_a_id  = module.subnet.public_subnet_a_id

  private_subnet_a_front_id = module.subnet.private_subnet_a_front_id
  private_subnet_c_front_id = module.subnet.private_subnet_c_front_id

  private_subnet_a_back_id  = module.subnet.private_subnet_a_back_id
  private_subnet_c_back_id  = module.subnet.private_subnet_c_back_id
}

# Security Group
module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

# Frontend ALB
module "alb_frontend" {
  source             = "./modules/alb/alb_frontend"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = [module.subnet.public_subnet_a_id, module.subnet.public_subnet_c_id]
  sg_alb_frontend_id = module.sg.sg_alb_frontend_id

  frontend_instance_map = {
    frontend-a = module.ec2.frontend_a_instance_id
    frontend-c = module.ec2.frontend_c_instance_id
  }
}

# Backend ALB
module "alb_backend" {
  source             = "./modules/alb/alb_backend"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = [module.subnet.private_subnet_a_back_id, module.subnet.private_subnet_c_back_id]
  sg_alb_backend_id  = module.sg.sg_alb_backend_id

  backend_instance_map = {
    backend-a = module.ec2.backend_a_instance_id
    backend-c = module.ec2.backend_c_instance_id
  }
}

# 백엔드 ECS 클러스터 (IAM 역할 + 서비스 + 태스크 정의 포함)
module "ecs_backend" {
  source              = "./modules/ecs"
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

# 프론트엔드 ECS 클러스터 (서비스 + 태스크 정의 포함)
module "ecs_frontend" {
  source              = "./modules/ecs"
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

# EC2 인스턴스 (frontend + backend)
module "ec2" {
  source = "./modules/ec2"

  ami_id               = var.ami_id
  instance_type        = var.instance_type
  instance_type_be     = var.instance_type_be
  key_pair_name        = var.key_pair_name

  public_subnet_a_id   = module.subnet.public_subnet_a_id
  public_subnet_c_id   = module.subnet.public_subnet_c_id
  
  //front subnet
  private_subnet_a_front_id  = module.subnet.private_subnet_a_front_id
  private_subnet_c_front_id  = module.subnet.private_subnet_c_front_id


  //back subnet
  private_subnet_a_back_id   = module.subnet.private_subnet_a_back_id 
  private_subnet_c_back_id   = module.subnet.private_subnet_c_back_id


  sg_frontend_id       = module.sg.frontend_sg_id
  sg_backend_id        = module.sg.backend_sg_id
  sg_openvpn_id        = module.sg.openvpn_sg_id

  project              = var.project
  environment          = var.environment

  # ECS에서 생성한 IAM 인스턴스 프로파일 이름 전달 (EC2가 ECS Task를 실행하기 위해 필수)
  #iam_instance_profile_name = module.ecs_backend.ecs_instance_profile_name
}

# RDS
module "rds" {
  source = "./modules/rds"

  vpc_id             = module.vpc.vpc_id
  private_subnet_a_db_id = module.subnet.private_subnet_a_db_id
  private_subnet_c_db_id = module.subnet.private_subnet_c_db_id

  backend_sg_id      = module.sg.backend_sg_id

  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage

  project     = var.project
  environment = var.environment
}

# Route53 alb_record
module "route53" {
  source = "./modules/route53"
  hosted_zone_id = var.dns_zone_id
  domain_name = var.domain_name

  frontend_zone_id = module.alb_frontend.zone_id
  frontend_dns_name = module.alb_frontend.frontend_alb_dns_name

  backend_zone_id = module.alb_backend.zone_id
  backend_dns_name = module.alb_backend.backend_alb_dns_name
}

# peering with shared vpc
data "aws_vpc" "shared" {
  id = var.shared_vpc_id  
}

data "aws_route_tables" "shared" {
  vpc_id = data.aws_vpc.shared.id
}

# VPC Peering 연결
module "vpc_peering" {
  source = "./modules/peering"
  
  requester_vpc_id = data.aws_vpc.shared.id
  accepter_vpc_id  = module.vpc.vpc_id
  
  requester_vpc_cidr = data.aws_vpc.shared.cidr_block
  accepter_vpc_cidr  = module.vpc.vpc_cidr_block
  
  requester_route_table_ids = data.aws_route_tables.shared.ids
  
  accepter_route_table_ids = {
    "public"  = module.vpc.public_route_table_id
    "private" = module.nat_gateway.private_route_table_id
  }
}