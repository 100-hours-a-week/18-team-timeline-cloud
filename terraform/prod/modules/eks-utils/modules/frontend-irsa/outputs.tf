output "iam_role_arn" {
  description = "ARN of the frontend IRSA IAM role"
  value       = aws_iam_role.frontend_irsa.arn
}

output "iam_role_name" {
  description = "Name of the frontend IRSA IAM role"
  value       = aws_iam_role.frontend_irsa.name
}

output "service_account_name" {
  description = "Name of the Kubernetes service account"
  value       = kubernetes_service_account.frontend.metadata[0].name
}

output "service_account_namespace" {
  description = "Namespace of the Kubernetes service account"
  value       = kubernetes_service_account.frontend.metadata[0].namespace
} 