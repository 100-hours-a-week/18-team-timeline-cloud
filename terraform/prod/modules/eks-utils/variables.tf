variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
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