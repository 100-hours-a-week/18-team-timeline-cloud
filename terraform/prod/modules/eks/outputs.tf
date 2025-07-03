output "cluster_id" {
  description = "EKS Cluster ID"
  value       = module.cluster.eks_cluster_id
}

output "cluster_name" {
  description = "EKS Cluster name"
  value       = module.cluster.eks_cluster_name
}

output "cluster_endpoint" {
  description = "EKS Cluster endpoint URL"
  value       = module.cluster.eks_cluster_endpoint
}

output "cluster_certificate_authority" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.cluster.eks_cluster_certificate_authority
}

output "cluster_oidc_issuer" {
  description = "OIDC Provider URL"
  value       = module.cluster.eks_oidc_issuer
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster (custom)"
  value       = module.cluster.eks_cluster_security_group_id
}

output "cluster_default_security_group_id" {
  description = "Security group ID automatically created by EKS (used by managed node groups)"
  value       = module.cluster.eks_cluster_default_security_group_id
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN used by EKS control plane"
  value       = module.cluster.eks_cluster_iam_role_arn
}

output "node_groups" {
  description = "EKS Node Groups information"
  value = {
    for name, ng in module.node_groups : name => {
      node_group_name = ng.node_group_name
      node_group_iam_role_arn = ng.node_group_iam_role_arn
    }
  }
}
