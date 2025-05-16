variable "vpc_id" {
  description = "ALB가 위치할 VPC ID"
  type        = string
}

variable "public_subnet_a_id" {
  description = "ALB용 Public Subnet A"
  type        = string
}

variable "public_subnet_c_id" {
  description = "ALB용 Public Subnet C"
  type        = string
}

variable "sg_alb_id" {
  description = "ALB에 적용할 보안 그룹 ID"
  type        = string
}
