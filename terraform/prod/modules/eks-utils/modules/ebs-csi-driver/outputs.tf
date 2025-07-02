output "ebs_csi_driver_iam_role_arn" {
  description = "ARN of the EBS CSI Driver IAM role"
  value       = aws_iam_role.ebs_csi_driver.arn
}

output "ebs_csi_driver_addon_name" {
  description = "Name of the EBS CSI Driver addon"
  value       = aws_eks_addon.ebs_csi_driver.addon_name
}

output "ebs_csi_driver_addon_version" {
  description = "Version of the EBS CSI Driver addon"
  value       = aws_eks_addon.ebs_csi_driver.addon_version
} 