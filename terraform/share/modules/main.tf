terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# VPC 생성
module "vpc" {
  source = "./vpc"
  
  cidr_block = var.vpc_cidr
  project = var.project
  environment = var.environment
}

# Subnet 생성
module "subnet" {
  source = "./subnet"

  vpc_id = module.vpc.vpc_id
  project = var.project
  environment = var.environment
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

# 퍼블릭 라우팅 테이블을 퍼블릭 서브넷에 연결
resource "aws_route_table_association" "public_a" {
  subnet_id      = module.subnet.public_subnet_a_id
  route_table_id = module.vpc.public_route_table_id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = module.subnet.public_subnet_c_id
  route_table_id = module.vpc.public_route_table_id
}

# NAT Gateway 생성
module "nat_gateway" {
  source = "./nat_gateway"

  vpc_id             = module.vpc.vpc_id
  project            = var.project
  environment        = var.environment
  public_subnet_a_id = module.subnet.public_subnet_a_id

  private_subnet_a_front_id = module.subnet.private_subnet_a_front_id
  private_subnet_c_front_id = module.subnet.private_subnet_c_front_id
  private_subnet_a_back_id  = module.subnet.private_subnet_a_back_id
  private_subnet_c_back_id  = module.subnet.private_subnet_c_back_id
  private_subnet_a_db_id    = module.subnet.private_subnet_a_db_id
  private_subnet_c_db_id    = module.subnet.private_subnet_c_db_id
}

# Peering을 위한 data sources
data "aws_vpc" "shared" {
  id = var.peering_vpc_id
}

data "aws_route_tables" "shared" {
  vpc_id = data.aws_vpc.shared.id
}

# VPC Peering (기존 VPC와 연결)
module "vpc_peering" {
  source = "./peering"
  
  project = var.project
  environment = var.environment
  requester_vpc_id = var.peering_vpc_id
  accepter_vpc_id  = module.vpc.vpc_id
  
  requester_vpc_cidr = data.aws_vpc.shared.cidr_block
  accepter_vpc_cidr  = module.vpc.vpc_cidr_block
  
  requester_route_table_ids = data.aws_route_tables.shared.ids
  
  accepter_route_table_ids = {
    "public"  = module.vpc.public_route_table_id
    "private" = module.nat_gateway.private_route_table_id
  }
} 