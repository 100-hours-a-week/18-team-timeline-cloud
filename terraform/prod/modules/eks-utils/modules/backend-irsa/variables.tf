variable "project" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "oidc_provider" {
  type        = string
  description = "OIDC provider URL without the https:// prefix"
}

variable "oidc_provider_arn" {
  type        = string
  description = "OIDC provider ARN"
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace"
  default     = "default"
} 