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

variable "project" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "enable_prometheus_metrics" {
  description = "Enable Prometheus metrics collection"
  type        = bool
  default     = true
}

variable "enable_cloudwatch_metrics" {
  description = "Enable CloudWatch metrics export"
  type        = bool
  default     = true
}

variable "enable_xray_traces" {
  description = "Enable X-Ray traces export"
  type        = bool
  default     = true
}

variable "prometheus_scrape_interval" {
  description = "Prometheus scrape interval"
  type        = string
  default     = "30s"
}

# ADOT 설정
variable "enable_cert_manager" {
  description = "Enable cert-manager"
  type        = bool
  default     = false
}

variable "cert_manager_addon_version" {
  description = "Version of the cert-manager add-on to use"
  type        = string
  default     = "v1.16.2-eksbuild.1"  # 최신 안정 버전
}

variable "enable_adot" {
  description = "Enable AWS Distro for OpenTelemetry"
  type        = bool
  default     = true
}

variable "addon_version" {
  description = "Version of the ADOT add-on to use"
  type        = string
  default     = "v0.117.0-eksbuild.1"  # 최신 안정 버전
}

 