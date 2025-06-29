# Security Groups
module "sg" {
  source = "./sg"
  vpc_id = var.vpc_id
}

# EC2
module "ec2" {
  source = "./ec2"

  ami_id           = var.ami_id
  instance_type    = var.instance_type
  instance_type_be = var.instance_type_be
  key_pair_name    = var.key_pair_name

  public_subnet_a_id = var.public_subnet_a_id
  public_subnet_c_id = var.public_subnet_c_id

  private_subnet_a_front_id = var.private_subnet_a_front_id
  private_subnet_c_front_id = var.private_subnet_c_front_id
  private_subnet_a_back_id  = var.private_subnet_a_back_id
  private_subnet_c_back_id  = var.private_subnet_c_back_id

  sg_frontend_id = module.sg.frontend_sg_id
  sg_backend_id  = module.sg.backend_sg_id
  sg_openvpn_id  = module.sg.openvpn_sg_id

  project     = var.project
  environment = var.environment
}

# ALB Frontend
module "alb_frontend" {
  source             = "./alb/alb_frontend"
  vpc_id             = var.vpc_id
  public_subnet_ids  = [var.public_subnet_a_id, var.public_subnet_c_id]
  sg_alb_frontend_id = module.sg.sg_alb_frontend_id

  frontend_instance_map = {
    frontend-a = module.ec2.frontend_a_instance_id
    frontend-c = module.ec2.frontend_c_instance_id
  }
}

# ALB Backend
module "alb_backend" {
  source             = "./alb/alb_backend"
  vpc_id             = var.vpc_id
  private_subnet_ids = [var.private_subnet_a_back_id, var.private_subnet_c_back_id]
  sg_alb_backend_id  = module.sg.sg_alb_backend_id

  backend_instance_map = {
    backend-a = module.ec2.backend_a_instance_id
    backend-c = module.ec2.backend_c_instance_id
  }
}

# ECS - Backend
module "ecs_backend" {
  source              = "./ecs"
  ecs_cluster_name    = "docker-v1-backend-cluster"
  container_name      = "docker-v1-backend"
  container_image     = "346011888304.dkr.ecr.ap-northeast-2.amazonaws.com/tamnara/be:latest"
  container_port      = 8080
  desired_count       = 2
  ecs_task_cpu        = "768"
  ecs_task_memory     = "1536"
  subnet_ids          = [var.private_subnet_a_back_id, var.private_subnet_c_back_id]
  security_group_ids  = [module.sg.backend_sg_id]
  target_group_arn    = module.alb_backend.backend_target_group_arn
}

# ECS - Frontend
module "ecs_frontend" {
  source              = "./ecs"
  ecs_cluster_name    = "docker-v1-frontend-cluster"
  container_name      = "docker-v1-frontend"
  container_image     = "346011888304.dkr.ecr.ap-northeast-2.amazonaws.com/tamnara/fe:latest"
  container_port      = 80
  desired_count       = 2
  ecs_task_cpu        = "256"
  ecs_task_memory     = "256"
  subnet_ids          = [var.private_subnet_a_front_id, var.private_subnet_c_front_id]
  security_group_ids  = [module.sg.frontend_sg_id]
  target_group_arn    = module.alb_frontend.frontend_target_group_arn
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

# Route53
module "route53" {
  source = "./route53"

  hosted_zone_id = var.dns_zone_id
  domain_name    = var.domain_name

  frontend_zone_id    = module.alb_frontend.zone_id
  frontend_dns_name   = module.alb_frontend.frontend_alb_dns_name
  backend_zone_id     = module.alb_backend.zone_id
  backend_dns_name    = module.alb_backend.backend_alb_dns_name

  proxy_ec2_ip        = var.proxy_ec2_ip
  back_ec2_ip         = var.back_ec2_ip
} 