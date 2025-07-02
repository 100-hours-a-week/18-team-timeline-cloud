output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = var.enable_bastion ? module.bastion[0].bastion_public_ip : null
}

output "bastion_iam_role_arn" {
  description = "IAM Role ARN for the bastion host"
  value       = var.enable_bastion ? module.bastion[0].bastion_iam_role_arn : null
}

output "bastion_instance_id" {
  description = "Instance ID of the bastion host"
  value       = var.enable_bastion ? module.bastion[0].bastion_instance_id : null
}

# ArgoCD Outputs
output "argocd_server_url" {
  description = "ArgoCD server URL"
  value       = var.enable_argocd ? module.argocd[0].argocd_server_url : null
}

output "argocd_initial_admin_password" {
  description = "ArgoCD initial admin password"
  value       = var.enable_argocd ? module.argocd[0].argocd_initial_admin_password : null
  sensitive   = true
}

output "argocd_admin_username" {
  description = "ArgoCD admin username"
  value       = var.enable_argocd ? module.argocd[0].argocd_admin_username : null
}

# External-DNS Outputs
output "external_dns_iam_role_arn" {
  description = "IAM Role ARN used by External-DNS"
  value       = var.enable_external_dns ? module.external_dns[0].external_dns_iam_role_arn : null
}

output "external_dns_service_account_name" {
  description = "Service Account name for External-DNS"
  value       = var.enable_external_dns ? module.external_dns[0].external_dns_service_account_name : null
}

# IRSA Outputs (Frontend + Backend)
output "app_namespace" {
  description = "Application namespace name"
  value       = module.irsa.app_namespace
}

output "frontend_irsa_role_arn" {
  description = "IAM Role ARN for Frontend IRSA"
  value       = module.irsa.frontend_irsa_role_arn
}

output "frontend_service_account_name" {
  description = "Service Account name for Frontend"
  value       = module.irsa.frontend_service_account_name
}

output "backend_irsa_role_arn" {
  description = "IAM Role ARN for Backend IRSA"
  value       = module.irsa.backend_irsa_role_arn
}

output "backend_service_account_name" {
  description = "Service Account name for Backend"
  value       = module.irsa.backend_service_account_name
} 