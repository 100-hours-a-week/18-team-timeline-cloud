# VPC 관련 변수
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR 블록"
  type        = string
}

# Subnet 관련 변수
variable "public_subnet_a_id" {
  description = "Public Subnet A ID"
  type        = string
}

variable "private_subnet_a_front_id" {
  description = "Private Subnet A Front ID"
  type        = string
}

variable "private_subnet_a_back_id" {
  description = "Private Subnet A Back ID"
  type        = string
}

variable "private_subnet_a_db_id" {
  description = "Private Subnet A DB ID"
  type        = string
}

# EC2 관련 변수
variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_type_be" {
  description = "EC2 backend instance type"
  type        = string
}

variable "key_pair_name" {
  description = "Key pair name for SSH access"
  type        = string
}

# Route53 관련 변수
variable "dns_zone_id" {
  description = "DNS Zone ID"
  type        = string
}

variable "domain_name" {
  description = "Domain name"
  type        = string
}

# 공통 변수
variable "project" {
  description = "Project name for tagging"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

# Private IP 설정
variable "front_private_ip" {
  description = "프론트엔드 EC2의 고정 프라이빗 IP"
  type        = string
}

variable "backend_private_ip" {
  description = "백엔드 EC2의 고정 프라이빗 IP"
  type        = string
}

variable "db_private_ip" {
  description = "DB EC2의 고정 프라이빗 IP"
  type        = string
} 