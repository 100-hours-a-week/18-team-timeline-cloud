variable "name" {
  type        = string
  description = "Name prefix for all resources"
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
}

variable "public_subnet_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_oidc_issuer" {
  description = "EKS cluster OIDC issuer URL"
  type = string
}

variable "region" {
  type = string
  default = "ap-northeast-2"
}

variable "key_name" {
  type = string
}

variable "bastion_instance_type" {
  type = string
  default = "t3.medium"
}

variable "enable_bastion" {
  type = bool
  default = false
}

variable "enable_alb_controller" {
  description = "Enable AWS Load Balancer Controller"
  type = bool
  default = true
}

variable "enable_external_dns" {
  description = "Enable External-DNS"
  type = bool
  default = true
}

variable "domain_filters" {
  description = "List of domains to filter for External-DNS"
  type = list(string)
  default = []
}

variable "enable_ebs_csi_driver" {
  description = "Enable AWS EBS CSI Driver (필수: EBS 볼륨 사용을 위해 필요)"
  type = bool
  default = true
}

variable "enable_secrets" {
  description = "Enable Parameter Store to Kubernetes Secret conversion"
  type        = bool
  default     = true
}

variable "enable_argocd" {
  description = "Enable ArgoCD"
  type = bool
  default = false
}

variable "argocd_safe_destroy" {
  description = "Enable safe destroy mode for ArgoCD (disable before destroy)"
  type = bool
  default = false
}

variable "argocd_chart_version" {
  description = "Version of ArgoCD Helm chart"
  type = string
  default = "7.7.8"
}

variable "enable_app_of_apps" {
  description = "Enable App of Apps pattern - automatically deploy root application"
  type = bool
  default = true
}

variable "repo_url" {
  description = "Git repository URL for ArgoCD applications"
  type = string
  default = "https://github.com/chang18-cloud/18-team-timeline-cloud"
}

variable "target_revision" {
  description = "Git branch/tag/commit for ArgoCD to track"
  type = string
  default = "HEAD"
}

variable "applications_path" {
  description = "Path in git repo where ArgoCD applications are stored"
  type = string
  default = "argocd/applications"
}

variable "node_iam_role_arns" {
  type = list(string)
}

variable "default_tags" {
  type = map(string)
}

# Frontend IRSA variables
variable "enable_frontend_irsa" {
  description = "Enable Frontend IRSA for S3 access"
  type = bool
  default = true
}

variable "frontend_namespace" {
  description = "Kubernetes namespace for frontend service account"
  type = string
  default = "tamnara-prod"
}

variable "frontend_service_account_name" {
  description = "Name of the frontend Kubernetes service account"
  type = string
  default = "frontend-service-account"
}

variable "frontend_s3_bucket_name" {
  description = "S3 bucket name for frontend environment files"
  type = string
  default = "tamnara-environment"
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace"
  default     = "default"
}

variable "project" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
} 