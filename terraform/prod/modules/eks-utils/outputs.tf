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
# output "argocd_server_url" {
#   description = "ArgoCD Server URL"
#   value       = var.enable_argocd ? module.argocd[0].argocd_server_url : null
# }

# output "argocd_initial_admin_password" {
#   description = "Initial admin password"
#   value       = var.enable_argocd ? module.argocd[0].argocd_initial_admin_password : null
#   sensitive   = true
# }

# output "argocd_namespace" {
#   description = "The namespace where ArgoCD is installed"
#   value       = var.enable_argocd ? module.argocd[0].argocd_namespace : null
# }

# External-DNS Outputs
output "external_dns_iam_role_arn" {
  description = "IAM Role ARN used by External-DNS"
  value       = var.enable_external_dns ? module.external_dns[0].external_dns_iam_role_arn : null
}

output "external_dns_service_account_name" {
  description = "Service Account name for External-DNS"
  value       = var.enable_external_dns ? module.external_dns[0].external_dns_service_account_name : null
}

# ============================================================================


 