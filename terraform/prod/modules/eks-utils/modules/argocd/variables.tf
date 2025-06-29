variable "argocd_chart_version" {
  description = "Version of ArgoCD Helm chart"
  type        = string
  default     = "7.7.8"  # Latest stable version as of 2024
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