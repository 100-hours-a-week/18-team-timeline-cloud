variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_oidc_issuer" {
  description = "The OIDC issuer URL for the cluster"
  type        = string
}

variable "cluster_oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "adot_addon_version" {
  description = "Version of ADOT addon to install"
  type        = string
  default     = "v0.88.0-eksbuild.1"
}

variable "adot_namespace" {
  description = "Kubernetes namespace for ADOT resources"
  type        = string
  default     = "aws-otel-system"
}

variable "adot_service_account_name" {
  description = "Service account name for ADOT collector"
  type        = string
  default     = "adot-collector"
}

variable "enable_prometheus_metrics" {
  description = "Enable Prometheus metrics collection"
  type        = bool
  default     = true
}

variable "enable_cloudwatch_metrics" {
  description = "Enable CloudWatch metrics collection"
  type        = bool
  default     = true
}

variable "enable_xray_traces" {
  description = "Enable X-Ray tracing"
  type        = bool
  default     = true
}

variable "prometheus_scrape_interval" {
  description = "Interval between Prometheus metric scrapes"
  type        = string
  default     = "30s"
} 