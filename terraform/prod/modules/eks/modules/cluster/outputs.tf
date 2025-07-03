output "eks_cluster_id" {
  description = "EKS Cluster ID"
  value       = aws_eks_cluster.this.id
}

output "eks_cluster_endpoint" {
  description = "EKS Cluster endpoint URL"
  value       = aws_eks_cluster.this.endpoint
}

output "eks_cluster_name" {
    description = "EKS Cluster name"
    value = aws_eks_cluster.this.name
}

output "eks_cluster_certificate_authority" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "eks_oidc_issuer" {
    description = "OIDC Provider URL"
    value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "eks_cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster (custom)"
  value       = aws_security_group.cluster.id
}

output "eks_cluster_default_security_group_id" {
  description = "Security group ID automatically created by EKS (used by managed node groups)"
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "eks_cluster_iam_role_arn" {
  description = "IAM role ARN used by EKS control plane"
  value       = aws_iam_role.this.arn
}
