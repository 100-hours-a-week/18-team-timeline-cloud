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

  private_subnet_a_front_id = var.private_subnet_a_front_id
  private_subnet_a_back_id  = var.private_subnet_a_back_id
  private_subnet_a_db_id    = var.private_subnet_a_db_id

  sg_frontend_id      = module.sg.sg_frontend_id
  sg_backend_id       = module.sg.sg_backend_id
  sg_reverse_proxy_id = module.sg.sg_reverse_proxy_id
  sg_db_id            = module.sg.sg_db_id

  project     = var.project
  environment = var.environment
}

# Route53
module "route53" {
  source = "./route53"

  hosted_zone_id = var.dns_zone_id
  domain_name    = var.domain_name

  proxy_ec2_ip = module.ec2.reverse_proxy_public_ip
  back_ec2_ip  = module.ec2.backend_a_instance_ip
} 