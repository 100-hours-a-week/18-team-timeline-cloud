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