variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_oidc_issuer" {
  description = "EKS cluster OIDC issuer URL"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "domain_filters" {
  description = "List of domains to filter for External-DNS"
  type        = list(string)
  default     = []
}

variable "default_tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default     = {}
} 