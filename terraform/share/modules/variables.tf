# VPC 관련 변수
variable "vpc_cidr_block" {
  description = "VPC의 CIDR 블록 (예: 10.0.0.0/16)"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC의 CIDR 블록 (예: 10.0.0.0/16)"
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

# Public Subnet CIDR
variable "public_subnet_a_cidr" {
  description = "Public Subnet A의 CIDR"
  type        = string
}

variable "public_subnet_c_cidr" {
  description = "Public Subnet C의 CIDR"
  type        = string
}

# Private Frontend Subnet CIDR
variable "private_subnet_a_front_cidr" {
  description = "Private Subnet A (Frontend)의 CIDR"
  type        = string
}

variable "private_subnet_c_front_cidr" {
  description = "Private Subnet C (Frontend)의 CIDR"
  type        = string
}

# Private Backend Subnet CIDR
variable "private_subnet_a_back_cidr" {
  description = "Private Subnet A (Backend)의 CIDR"
  type        = string
}

variable "private_subnet_c_back_cidr" {
  description = "Private Subnet C (Backend)의 CIDR"
  type        = string
}

# Private DB Subnet CIDR
variable "private_subnet_a_db_cidr" {
  description = "Private Subnet A (DB)의 CIDR"
  type        = string
}

variable "private_subnet_c_db_cidr" {
  description = "Private Subnet C (DB)의 CIDR"
  type        = string
}

# Peering 관련 변수
variable "peering_vpc_id" {
  description = "Peering할 기존 VPC ID"
  type        = string
}

variable "front_private_ip" {
  description = "프론트엔드 EC2의 고정 프라이빗 IP"
  type        = string
  default     = "10.0.10.5"
}

variable "backend_private_ip" {
  description = "백엔드 EC2의 고정 프라이빗 IP"
  type        = string
  default     = "10.0.20.5"
}

variable "db_private_ip" {
  description = "DB EC2의 고정 프라이빗 IP"
  type        = string
  default     = "10.0.30.5"
} 