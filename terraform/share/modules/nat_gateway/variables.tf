variable "vpc_id" {
  description = "NAT Gateway가 생성될 VPC ID"
  type        = string
}

variable "public_subnet_a_id" {
  description = "NAT Gateway가 위치할 퍼블릭 서브넷 A ID"
  type        = string
}

# Front - A SubnetId
variable "private_subnet_a_front_id" {
  description = "Private Subnet A (Frontend)의 ID"
  type        = string
}
# Front - C SubnetId
variable "private_subnet_c_front_id" {
  description = "Private Subnet C (Frontend)의 ID"
  type        = string
}
# Back - A SubnetId
variable "private_subnet_a_back_id" {
  description = "Private Subnet A (Backend)의 ID"
  type        = string
}

# Back - C SubnetId
variable "private_subnet_c_back_id" {
  description = "Private Subnet C (Backend)의 ID"
  type        = string
}

# DB - A SubnetId
variable "private_subnet_a_db_id" {
  description = "Private Subnet A (RDS)의 ID"
  type        = string
}

# DB - C SubnetId
variable "private_subnet_c_db_id" {
  description = "Private Subnet C (RDS)의 ID"
  type        = string
}