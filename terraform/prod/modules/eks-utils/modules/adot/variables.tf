variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "enable_adot" {
  description = "Enable AWS Distro for OpenTelemetry"
  type        = bool
  default     = false
}

variable "addon_version" {
  description = "Version of the ADOT add-on to use"
  type        = string
  default     = "v0.117.0-eksbuild.1" 
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default     = {}
} 