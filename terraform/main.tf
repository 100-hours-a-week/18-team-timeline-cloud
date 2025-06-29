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

# 공유 리소스 - VPC / Subnet / NAT Gateway / Peering
module "shared" {
  source = "./share/modules"

  # VPC 설정
  vpc_cidr_block = var.vpc_cidr_block
  
  # 가용 영역
  az_a = var.az_a
  az_c = var.az_c

  # Public Subnet CIDR
  public_subnet_a_cidr = var.public_subnet_a_cidr
  public_subnet_c_cidr = var.public_subnet_c_cidr

  # Private Frontend Subnet CIDR
  private_subnet_a_front_cidr = var.private_subnet_a_front_cidr
  private_subnet_c_front_cidr = var.private_subnet_c_front_cidr

  # Private Backend Subnet CIDR
  private_subnet_a_back_cidr = var.private_subnet_a_back_cidr
  private_subnet_c_back_cidr = var.private_subnet_c_back_cidr

  # Private DB Subnet CIDR
  private_subnet_a_db_cidr = var.private_subnet_a_db_cidr
  private_subnet_c_db_cidr = var.private_subnet_c_db_cidr

  # Peering 설정
  peering_vpc_id = var.peering_vpc_id
}

# dev 환경 전체
module "dev" {
  source = "./dev/modules"

  # VPC 및 네트워크
  vpc_id = module.shared.vpc_id
  
  public_subnet_a_id = module.shared.public_subnet_a_id
  private_subnet_a_front_id = module.shared.private_subnet_a_front_id
  private_subnet_a_back_id  = module.shared.private_subnet_a_back_id
  private_subnet_a_db_id    = module.shared.private_subnet_a_db_id

  # EC2 설정
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  instance_type_be = var.instance_type_be
  key_pair_name    = var.key_pair_name

  # Route53 설정
  dns_zone_id = var.dns_zone_id
  domain_name = var.domain_name

  # 공통 설정
  project     = var.project
  environment = var.environment
}

# prod 환경 전체
module "prod" {
  source = "./prod/modules"

  # VPC 및 네트워크
  vpc_id = module.shared.vpc_id
  vpc_cidr_block = module.shared.vpc_cidr_block
  
  public_subnet_a_id = module.shared.public_subnet_a_id
  public_subnet_c_id = module.shared.public_subnet_c_id
  
  private_subnet_a_front_id = module.shared.private_subnet_a_front_id
  private_subnet_c_front_id = module.shared.private_subnet_c_front_id
  private_subnet_a_back_id  = module.shared.private_subnet_a_back_id
  private_subnet_c_back_id  = module.shared.private_subnet_c_back_id
  private_subnet_a_db_id    = module.shared.private_subnet_a_db_id
  private_subnet_c_db_id    = module.shared.private_subnet_c_db_id
  
  public_route_table_id  = module.shared.public_route_table_id
  private_route_table_id = module.shared.private_route_table_id

  # EC2 설정
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  instance_type_be = var.instance_type_be
  key_pair_name    = var.key_pair_name

  # RDS 설정
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage

  # OpenVPN 설정
  openvpn_eip_allocation_id = "eipalloc-049804da24b652d0b"

  # 공통 설정
  project     = var.project
  environment = var.environment
}