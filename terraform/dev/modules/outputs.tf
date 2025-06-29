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
output "frontend_a_instance_id" {
  description = "Frontend A Instance ID"
  value       = module.ec2.frontend_a_instance_id
}

output "backend_a_instance_id" {
  description = "Backend A Instance ID"
  value       = module.ec2.backend_a_instance_id
}

output "reverse_proxy_public_ip" {
  description = "Reverse Proxy Public IP"
  value       = module.ec2.reverse_proxy_public_ip
}

output "backend_a_instance_ip" {
  description = "Backend A Instance Public IP"
  value       = module.ec2.backend_a_instance_ip
} 