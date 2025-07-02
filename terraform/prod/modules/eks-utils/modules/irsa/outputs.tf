# ============================================================================
# NAMESPACE OUTPUTS
# ============================================================================
output "app_namespace" {
  description = "Application namespace name"
  value       = var.create_namespace ? kubernetes_namespace.app_namespace[0].metadata[0].name : var.app_namespace
}

# ============================================================================
# FRONTEND IRSA OUTPUTS
# ============================================================================
output "frontend_irsa_role_arn" {
  description = "ARN of the frontend IRSA role"
  value       = var.enable_frontend_irsa ? aws_iam_role.frontend_irsa[0].arn : null
}

output "frontend_service_account_name" {
  description = "Name of the frontend service account"
  value       = var.enable_frontend_irsa ? kubernetes_service_account.frontend[0].metadata[0].name : null
}

# ============================================================================
# BACKEND IRSA OUTPUTS
# ============================================================================
output "backend_irsa_role_arn" {
  description = "ARN of the backend IRSA role"
  value       = var.enable_backend_irsa ? aws_iam_role.backend_irsa[0].arn : null
}

output "backend_service_account_name" {
  description = "Name of the backend service account"
  value       = var.enable_backend_irsa ? kubernetes_service_account.backend[0].metadata[0].name : null
} 