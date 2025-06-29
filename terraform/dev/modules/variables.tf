# VPC 관련 변수
variable "vpc_id" {
  description = "VPC ID"
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

# 공통 변수
variable "project" {
  description = "Project name for tagging"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
} 