variable "vpc_id" {
  description = "VPC ID where the security groups will be created"
  type        = string
}

variable "alb_sg_id" {
  description = "ALB의 보안 그룹 ID (ALB → Frontend 허용)"
  type        = string
}
