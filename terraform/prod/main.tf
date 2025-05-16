provider "aws" {
  region                  = "ap-northeast-2"
  profile                 = "default"
}


# 1. VPC
module "vpc" {
  source = "./modules/vpcterraform apply"

  cidr_block           = var.vpc_cidr_block
  public_subnet_a_id   = module.subnet.public_subnet_a_id
  public_subnet_c_id   = module.subnet.public_subnet_c_id
}

# 2. Subnet
module "subnet" {
  source = "./modules/subnet"

  vpc_id                 = module.vpc.vpc_id
  az_a                   = var.az_a
  az_c                   = var.az_c
  public_subnet_a_cidr   = var.public_subnet_a_cidr
  public_subnet_c_cidr   = var.public_subnet_c_cidr
  private_subnet_a_cidr  = var.private_subnet_a_cidr
  private_subnet_c_cidr  = var.private_subnet_c_cidr
}

# 3. NAT Gateway + Private RT
module "nat_gateway" {
  source = "./modules/nat_gateway"

  vpc_id                = module.vpc.vpc_id
  public_subnet_a_id    = module.subnet.public_subnet_a_id
  private_subnet_a_id   = module.subnet.private_subnet_a_id
  private_subnet_c_id   = module.subnet.private_subnet_c_id
}

# 4. 보안 그룹
module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
 # alb_sg_id = module.nat_gateway.alb_sg_id  # ✅ 이 이름만 쓴다
  
}

# 5. ALB + Target Group
module "alb" {
  source              = "./modules/alb"
  vpc_id              = module.vpc.vpc_id
  public_subnet_a_id  = module.subnet.public_subnet_a_id
  public_subnet_c_id  = module.subnet.public_subnet_c_id
  sg_alb_id           = module.sg.alb_sg_id  # ✅ 이 이름만 쓴다
}

# 6. EC2 (frontend, backend + target group attachment)
module "ec2" {
  source = "./modules/ec2"

  ami_id               = var.ami_id
  instance_type        = var.instance_type
  private_subnet_a_id  = module.subnet.private_subnet_a_id
  private_subnet_c_id  = module.subnet.private_subnet_c_id
  sg_frontend_id       = module.sg.frontend_sg_id
  sg_backend_id        = module.sg.backend_sg_id
  tg_frontend_arn      = module.alb.alb_target_group_frontend
  tg_backend_arn       = module.alb.alb_target_group_backend

  project              = var.project
  environment          = var.environment
}
