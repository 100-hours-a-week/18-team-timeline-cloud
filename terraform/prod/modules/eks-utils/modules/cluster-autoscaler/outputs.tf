output "cluster_autoscaler_role_arn" {
  description = "ARN of the IAM role used by Cluster Autoscaler"
  value       = aws_iam_role.cluster_autoscaler.arn
} 