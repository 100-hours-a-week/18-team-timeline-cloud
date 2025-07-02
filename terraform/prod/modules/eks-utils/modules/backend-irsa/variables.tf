variable "name" {
  type        = string
  description = "Name prefix for all resources"
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

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
} 