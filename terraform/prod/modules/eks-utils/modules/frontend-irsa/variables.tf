variable "name" {
  description = "Project name prefix"
  type        = string
}

variable "cluster_oidc_issuer" {
  description = "EKS cluster OIDC issuer URL"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for the service account"
  type        = string
  default     = "tamnara-prod"
}

variable "service_account_name" {
  description = "Name of the Kubernetes service account"
  type        = string
  default     = "frontend-service-account"
}

variable "s3_bucket_name" {
  description = "S3 bucket name for environment files"
  type        = string
  default     = "tamnara-environment"
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
} 