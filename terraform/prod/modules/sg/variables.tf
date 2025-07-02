variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
}

# variable "alb_sg_id" {
#   description = "ALB의 보안 그룹 ID (ALB → Frontend 허용)"
#   type        = string
# }

variable "project" {
  description = "프로젝트 이름"
  type        = string
}

variable "environment" {
  description = "환경 (예: dev, prod)"
  type        = string
}
