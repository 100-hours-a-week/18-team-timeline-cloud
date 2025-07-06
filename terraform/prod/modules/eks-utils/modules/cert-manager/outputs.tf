output "cert_manager_addon_arn" {
  description = "ARN of the cert-manager EKS addon"
  value       = var.enable_cert_manager ? aws_eks_addon.cert_manager[0].arn : null
}

output "cert_manager_addon_id" {
  description = "ID of the cert-manager EKS addon"
  value       = var.enable_cert_manager ? aws_eks_addon.cert_manager[0].id : null
} 