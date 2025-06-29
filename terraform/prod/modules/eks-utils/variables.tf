variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_oidc_issuer" {
  description = "EKS cluster OIDC issuer URL"
  type = string
}

variable "region" {
  type = string
  default = "ap-northeast-2"
}

variable "key_name" {
  type = string
}

variable "bastion_instance_type" {
  type = string
  default = "t3.medium"
}

variable "enable_bastion" {
  type = bool
  default = false
}

variable "enable_alb_controller" {
  description = "Enable AWS Load Balancer Controller"
  type = bool
  default = true
}

variable "enable_argocd" {
  description = "Enable ArgoCD"
  type = bool
  default = false
}

variable "argocd_chart_version" {
  description = "Version of ArgoCD Helm chart"
  type = string
  default = "7.7.8"
}

variable "node_iam_role_arns" {
  type = list(string)
}

variable "default_tags" {
  type = map(string)
} 