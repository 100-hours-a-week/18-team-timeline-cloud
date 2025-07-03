variable "name" {
  type        = string
  description = "Name prefix for all resources"
}

variable "cluster_oidc_issuer" {
  description = "EKS cluster OIDC issuer URL"
  type = string
}

variable "default_tags" {
  type = map(string)
}

variable "enable_secrets" {
  description = "Enable Parameter Store to Kubernetes Secret conversion"
  type        = bool
  default     = true
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