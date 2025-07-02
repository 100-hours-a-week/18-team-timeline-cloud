output "role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.backend_role.arn
}

output "role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.backend_role.name
}

output "service_account_name" {
  description = "Name of the Kubernetes service account"
  value       = kubernetes_service_account.backend.metadata[0].name
} 