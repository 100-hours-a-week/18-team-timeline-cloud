# Security Groups outputs
output "sg_frontend_id" {
  description = "Frontend Security Group ID"
  value       = module.sg.sg_frontend_id
}

output "sg_backend_id" {
  description = "Backend Security Group ID"
  value       = module.sg.sg_backend_id
}

output "sg_reverse_proxy_id" {
  description = "Reverse Proxy Security Group ID"
  value       = module.sg.sg_reverse_proxy_id
}

output "sg_db_id" {
  description = "Database Security Group ID"
  value       = module.sg.sg_db_id
}

# EC2 outputs
output "frontend_instance_id" {
  description = "Frontend EC2 Instance ID"
  value       = module.ec2.frontend_instance_id
}

output "backend_instance_id" {
  description = "Backend EC2 Instance ID"
  value       = module.ec2.backend_instance_id
}

output "db_instance_id" {
  description = "DB EC2 Instance ID"
  value       = module.ec2.db_instance_id
}

output "frontend_instance_ip" {
  description = "Frontend EC2 Instance Private IP"
  value       = module.ec2.frontend_instance_ip
}

output "backend_instance_ip" {
  description = "Backend EC2 Instance Private IP"
  value       = module.ec2.backend_instance_ip
}

output "db_instance_ip" {
  description = "DB EC2 Instance Private IP"
  value       = module.ec2.db_instance_ip
} 