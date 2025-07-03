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