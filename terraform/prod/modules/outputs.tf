# Security Groups outputs
output "frontend_sg_id" {
  description = "Frontend Security Group ID"
  value       = module.sg.frontend_sg_id
}

output "backend_sg_id" {
  description = "Backend Security Group ID"
  value       = module.sg.backend_sg_id
}

output "openvpn_sg_id" {
  description = "OpenVPN Security Group ID"
  value       = module.sg.openvpn_sg_id
}

output "sg_alb_frontend_id" {
  description = "ALB Frontend Security Group ID"
  value       = module.sg.sg_alb_frontend_id
}

output "sg_alb_backend_id" {
  description = "ALB Backend Security Group ID"
  value       = module.sg.sg_alb_backend_id
}

# EC2 outputs
output "frontend_a_instance_id" {
  description = "Frontend A Instance ID"
  value       = module.ec2.frontend_a_instance_id
}

output "frontend_c_instance_id" {
  description = "Frontend C Instance ID"
  value       = module.ec2.frontend_c_instance_id
}

output "backend_a_instance_id" {
  description = "Backend A Instance ID"
  value       = module.ec2.backend_a_instance_id
}

output "backend_c_instance_id" {
  description = "Backend C Instance ID"
  value       = module.ec2.backend_c_instance_id
}

# ALB outputs
output "frontend_alb_dns_name" {
  description = "Frontend ALB DNS Name"
  value       = module.alb_frontend.frontend_alb_dns_name
}

output "backend_alb_dns_name" {
  description = "Backend ALB DNS Name"
  value       = module.alb_backend.backend_alb_dns_name
}

output "frontend_target_group_arn" {
  description = "Frontend Target Group ARN"
  value       = module.alb_frontend.frontend_target_group_arn
}

output "backend_target_group_arn" {
  description = "Backend Target Group ARN"
  value       = module.alb_backend.backend_target_group_arn
}

output "frontend_zone_id" {
  description = "Frontend ALB Zone ID"
  value       = module.alb_frontend.zone_id
}

output "backend_zone_id" {
  description = "Backend ALB Zone ID"
  value       = module.alb_backend.zone_id
}

# ECS outputs
output "ecs_backend_cluster_name" {
  description = "ECS Backend Cluster Name"
  value       = module.ecs_backend.ecs_cluster_id
}

output "ecs_frontend_cluster_name" {
  description = "ECS Frontend Cluster Name"
  value       = module.ecs_frontend.ecs_cluster_id
}

# RDS outputs
output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = module.rds.rds_endpoint
}

output "rds_port" {
  description = "RDS Port"
  value       = module.rds.rds_port
}

# Route53 outputs
output "frontend_domain_name" {
  description = "Frontend Domain Name"
  value       = module.route53.frontend_domain_name
}

output "backend_domain_name" {
  description = "Backend Domain Name"
  value       = module.route53.backend_domain_name
} 