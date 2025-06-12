# VPC CIDR
variable "cidr_block" {
  description = "VPC의 CIDR 블록 (예: 10.0.0.0/16)"
  type        = string
}

# 퍼블릭 서브넷 ID (라우팅 연동용)
variable "public_subnet_a_id" {
  description = "Public Subnet A의 ID"
  type        = string
}

variable "public_subnet_c_id" {
  description = "Public Subnet C의 ID"
  type        = string
}
