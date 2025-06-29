# VPC 및 네트워크 관련 변수
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR 블록"
  type        = string
}

variable "public_subnet_a_id" {
  description = "Public Subnet A ID"
  type        = string
}

variable "public_subnet_c_id" {
  description = "Public Subnet C ID"
  type        = string
}

variable "private_subnet_a_front_id" {
  description = "Private Subnet A Front ID"
  type        = string
}

variable "private_subnet_c_front_id" {
  description = "Private Subnet C Front ID"
  type        = string
}

variable "private_subnet_a_back_id" {
  description = "Private Subnet A Back ID"
  type        = string
}

variable "private_subnet_c_back_id" {
  description = "Private Subnet C Back ID"
  type        = string
}

variable "private_subnet_a_db_id" {
  description = "Private Subnet A DB ID"
  type        = string
}

variable "private_subnet_c_db_id" {
  description = "Private Subnet C DB ID"
  type        = string
}

variable "public_route_table_id" {
  description = "Public Route Table ID"
  type        = string
}

variable "private_route_table_id" {
  description = "Private Route Table ID"
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

# RDS 관련 변수
variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Database instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Database allocated storage"
  type        = number
  default     = 20
}

# OpenVPN 관련 변수
variable "openvpn_eip_allocation_id" {
  description = "OpenVPN EIP Allocation ID"
  type        = string
}

# ArgoCD 관련 변수
variable "enable_argocd" {
  description = "Enable ArgoCD"
  type        = bool
  default     = false
}

variable "argocd_chart_version" {
  description = "Version of ArgoCD Helm chart"
  type        = string
  default     = "7.7.8"
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