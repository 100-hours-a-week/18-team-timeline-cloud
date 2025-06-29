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

# RDS outputs
output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = module.rds.rds_endpoint
}

output "rds_port" {
  description = "RDS Port"
  value       = module.rds.rds_port
}

# EKS outputs
output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_id" {
  description = "EKS Cluster ID"
  value       = module.eks.cluster_id
}

output "node_groups" {
  description = "EKS Node Groups information"
  value       = module.eks.node_groups
}

# EKS Utils outputs
output "bastion_instance_id" {
  description = "Bastion Instance ID"
  value       = module.eks_utils.bastion_instance_id
}

output "bastion_public_ip" {
  description = "Bastion Public IP"
  value       = module.eks_utils.bastion_public_ip
}

# OpenVPN outputs
output "openvpn_instance_id" {
  description = "OpenVPN Instance ID"
  value       = module.openvpn.openvpn_instance_id
}

output "openvpn_public_ip" {
  description = "OpenVPN Public IP"
  value       = module.openvpn.openvpn_public_ip
} 