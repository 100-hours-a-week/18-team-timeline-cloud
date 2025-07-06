variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "enable_cert_manager" {
  description = "Enable cert-manager"
  type        = bool
  default     = false
}

variable "addon_version" {
  description = "Version of the cert-manager add-on to use"
  type        = string
  default     = "v1.16.2-eksbuild.1"
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default     = {}
} 