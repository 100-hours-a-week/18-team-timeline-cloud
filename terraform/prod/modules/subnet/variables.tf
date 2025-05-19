# 사용할 VPC ID
variable "vpc_id" {
  description = "서브넷을 생성할 VPC ID"
  type        = string
}

# 가용 영역
variable "az_a" {
  description = "가용 영역 A (예: ap-northeast-2a)"
  type        = string
}

variable "az_c" {
  description = "가용 영역 C (예: ap-northeast-2c)"
  type        = string
}

# CIDR 블록들
variable "public_subnet_a_cidr" {
  description = "Public Subnet A의 CIDR"
  type        = string
}

variable "public_subnet_c_cidr" {
  description = "Public Subnet C의 CIDR"
  type        = string
}

variable "private_subnet_a_cidr" {
  description = "Private Subnet A의 CIDR"
  type        = string
}

variable "private_subnet_c_cidr" {
  description = "Private Subnet C의 CIDR"
  type        = string
}
