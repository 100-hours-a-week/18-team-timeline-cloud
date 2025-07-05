output "adot_addon_arn" {
  description = "ARN of the ADOT EKS addon"
  value       = aws_eks_addon.adot.arn
}

output "adot_addon_status" {
  description = "Status of the ADOT EKS addon"
  value       = aws_eks_addon.adot.status
}

output "adot_collector_role_arn" {
  description = "ARN of the ADOT collector IAM role"
  value       = aws_iam_role.adot_collector.arn
}

output "adot_namespace" {
  description = "Namespace where ADOT resources are deployed"
  value       = var.adot_namespace
}

output "adot_service_account_name" {
  description = "Name of the ADOT collector service account"
  value       = var.adot_service_account_name
}

output "adot_collector_service_name" {
  description = "Name of the ADOT collector service"
  value       = kubernetes_service.adot_collector.metadata[0].name
}

output "adot_collector_grpc_endpoint" {
  description = "OTLP gRPC endpoint for ADOT collector"
  value       = "http://${kubernetes_service.adot_collector.metadata[0].name}.${var.adot_namespace}.svc.cluster.local:4317"
}

output "adot_collector_http_endpoint" {
  description = "OTLP HTTP endpoint for ADOT collector"
  value       = "http://${kubernetes_service.adot_collector.metadata[0].name}.${var.adot_namespace}.svc.cluster.local:4318"
} 