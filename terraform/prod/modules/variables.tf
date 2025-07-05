# VPC 및 네트워크 관련 변수
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR 블록"
  type        = string
}

variable "public_subnet_a_id" {
  description = "Public Subnet A ID"
  type        = string
}

variable "public_subnet_c_id" {
  description = "Public Subnet C ID"
  type        = string
}

variable "private_subnet_a_front_id" {
  description = "Private Subnet A Front ID"
  type        = string
}

variable "private_subnet_c_front_id" {
  description = "Private Subnet C Front ID"
  type        = string
}

variable "private_subnet_a_back_id" {
  description = "Private Subnet A Back ID"
  type        = string
}

variable "private_subnet_c_back_id" {
  description = "Private Subnet C Back ID"
  type        = string
}

variable "private_subnet_a_db_id" {
  description = "Private Subnet A DB ID"
  type        = string
}

variable "private_subnet_c_db_id" {
  description = "Private Subnet C DB ID"
  type        = string
}

variable "public_route_table_id" {
  description = "Public Route Table ID"
  type        = string
}

variable "private_route_table_id" {
  description = "Private Route Table ID"
  type        = string
}

# EC2 관련 변수
variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_type_be" {
  description = "EC2 backend instance type"
  type        = string
}

variable "key_pair_name" {
  description = "Key pair name for SSH access"
  type        = string
}

# RDS 관련 변수
variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Database instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Database allocated storage"
  type        = number
  default     = 20
}

variable "db_snapshot_identifier" {
  description = "DB snapshot identifier to restore from (optional)"
  type        = string
  default     = null
}

# OpenVPN 관련 변수
variable "openvpn_eip_allocation_id" {
  description = "OpenVPN EIP Allocation ID"
  type        = string
}

# ArgoCD 관련 변수
variable "enable_argocd" {
  description = "Enable ArgoCD"
  type        = bool
  default     = false
}

variable "argocd_safe_destroy" {
  description = "Enable safe destroy mode for ArgoCD (disable before destroy)"
  type        = bool
  default     = false
}

variable "argocd_chart_version" {
  description = "Version of ArgoCD Helm chart"
  type        = string
  default     = "7.7.8"
}

variable "enable_app_of_apps" {
  description = "Enable App of Apps pattern - automatically deploy root application"
  type        = bool
  default     = true
}

variable "repo_url" {
  description = "Git repository URL for ArgoCD applications"
  type        = string
  default     = "https://github.com/chang18-cloud/18-team-timeline-cloud"
}

variable "target_revision" {
  description = "Git branch/tag/commit for ArgoCD to track"
  type        = string
  default     = "HEAD"
}

variable "applications_path" {
  description = "Path in git repo where ArgoCD applications are stored"
  type        = string
  default     = "argocd/applications"
}

# External-DNS 관련 변수
variable "enable_external_dns" {
  description = "Enable External-DNS"
  type        = bool
  default     = true
}

variable "domain_filters" {
  description = "List of domains to filter for External-DNS"
  type        = list(string)
  default     = []
}

# 공통 변수
variable "project" {
  description = "Project name for tagging"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
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

# ADOT 설정
variable "enable_adot" {
  description = "Enable AWS Distro for OpenTelemetry"
  type        = bool
  default     = false
} 