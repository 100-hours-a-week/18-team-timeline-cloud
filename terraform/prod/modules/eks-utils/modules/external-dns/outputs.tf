output "external_dns_iam_role_arn" {
  description = "ARN of the IAM role used by External-DNS"
  value       = aws_iam_role.external_dns.arn
}

output "external_dns_service_account_name" {
  description = "Name of the Kubernetes service account for External-DNS"
  value       = kubernetes_service_account.external_dns.metadata[0].name
}

output "external_dns_helm_release_status" {
  description = "Status of the Helm release for External-DNS"
  value       = helm_release.external_dns.status
} 