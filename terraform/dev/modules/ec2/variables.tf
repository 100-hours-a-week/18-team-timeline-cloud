# EC2 모듈에 필요한 변수 정의

variable "ami_id" {
  description = "AMI ID for the EC2 instances (ECS Optimized)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_type_be" {
  description = "EC2 instance type"
  type        = string
}

variable "key_pair_name" {
  description = "Key pair name for SSH access"
  type        = string
}

//프록시 서버 셔브넷
variable "public_subnet_a_id" {
  description = "Private Subnet A ID"
  type        = string
}


//ec2 fornt subnet
variable "private_subnet_a_front_id" {
  description = "Private Subnet A ID"
  type        = string
}

//ec2 back subnet
variable "private_subnet_a_back_id" {
  description = "Private Subnet A Back ID"
  type        = string
}

//ec2 db subnet
variable "private_subnet_a_db_id" {
  description = "Private Subnet A DB ID"
  type        = string
}
//보안그룹
variable "sg_frontend_id" {
  description = "Security group ID for frontend EC2 instances"
  type        = string
}

variable "sg_backend_id" {
  description = "Security group ID for backend EC2 instanc9es"
  type        = string
}

variable "sg_reverse_proxy_id" {
  description = "Security group ID for reverse_proxy EC2 instances"
  type        = string
}

variable "sg_db_id" {
  description = "Security group ID for MySQL EC2 instance"
  type        = string
}




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

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
