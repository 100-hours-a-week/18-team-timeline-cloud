variable "name" {
  description = "Project name prefix"
  type        = string
}

variable "cluster_oidc_issuer" {
  description = "EKS cluster OIDC issuer URL"
  type        = string
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# ============================================================================
# NAMESPACE VARIABLES
# ============================================================================
variable "create_namespace" {
  description = "Whether to create the application namespace"
  type        = bool
  default     = true
}

variable "app_namespace" {
  description = "Kubernetes namespace for frontend applications"
  type        = string
  default     = "tamnara-prod"
}

variable "backend_namespace" {
  description = "Kubernetes namespace for backend applications"
  type        = string
  default     = "default"
}

# ============================================================================
# FRONTEND IRSA VARIABLES
# ============================================================================
variable "enable_frontend_irsa" {
  description = "Enable Frontend IRSA for S3 access"
  type        = bool
  default     = true
}

variable "frontend_service_account_name" {
  description = "Name of the frontend Kubernetes service account"
  type        = string
  default     = "frontend-service-account"
}

variable "frontend_s3_bucket_name" {
  description = "S3 bucket name for frontend environment files"
  type        = string
  default     = "tamnara-environment"
}

# ============================================================================
# BACKEND IRSA VARIABLES
# ============================================================================
variable "enable_backend_irsa" {
  description = "Enable Backend IRSA for S3 access"
  type        = bool
  default     = true
}

variable "backend_service_account_name" {
  description = "Name of the backend Kubernetes service account"
  type        = string
  default     = "backend-service-account"
} 