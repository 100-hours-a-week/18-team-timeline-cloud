output "adot_addon_arn" {
  description = "ARN of the ADOT add-on"
  value       = var.enable_adot ? aws_eks_addon.adot[0].arn : null
}

output "adot_role_arn" {
  description = "ARN of the IAM role used by ADOT"
  value       = var.enable_adot ? aws_iam_role.adot[0].arn : null
} 