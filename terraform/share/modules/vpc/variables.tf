# VPC CIDR
variable "cidr_block" {
  description = "VPC의 CIDR 블록 (예: 10.0.0.0/16)"
  type        = string
}

variable "project" {
  description = "프로젝트 이름"
  type        = string
}

variable "environment" {
  description = "환경 (예: dev, prod)"
  type        = string
}
