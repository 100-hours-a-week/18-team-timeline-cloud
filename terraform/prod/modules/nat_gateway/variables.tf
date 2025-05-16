variable "vpc_id" {
  description = "NAT Gateway가 생성될 VPC ID"
  type        = string
}

variable "public_subnet_a_id" {
  description = "NAT Gateway가 위치할 퍼블릭 서브넷 A ID"
  type        = string
}

variable "private_subnet_a_id" {
  description = "라우팅할 Private Subnet A ID"
  type        = string
}

variable "private_subnet_c_id" {
  description = "라우팅할 Private Subnet C ID"
  type        = string
}


