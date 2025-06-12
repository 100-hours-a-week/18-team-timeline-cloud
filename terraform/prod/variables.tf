# VPC
variable "vpc_cidr_block" {
  description = "VPC의 CIDR 블록"
  type        = string
}

# 서브넷
variable "public_subnet_a_cidr" {
  description = "퍼블릭 서브넷 A의 CIDR"
  type        = string
}

variable "public_subnet_c_cidr" {
  description = "퍼블릭 서브넷 C의 CIDR"
  type        = string
}

// 프론트 서브넷 CIDR
variable "private_subnet_a_front_cidr" {
  description = "프라이빗 서브넷 A의 CIDR"
  type        = string
}

variable "private_subnet_c_front_cidr" {
  description = "프라이빗 서브넷 C의 CIDR"
  type        = string
}

// 백엔드 서브넷 CIDR
variable "private_subnet_a_back_cidr" {
  description = "프라이빗 서브넷 A의 CIDR"
  type        = string
}

variable "private_subnet_c_back_cidr" {
  description = "프라이빗 서브넷 C의 CIDR"
  type        = string
}

// DB 서브넷 CIDR
variable "private_subnet_a_db_cidr" {
  description = "프라이빗 서브넷 A (DB)의 CIDR"
  type        = string
}
variable "private_subnet_c_db_cidr" {
  description = "프라이빗 서브넷 C (DB)의 CIDR"
  type        = string
}


# 가용 영역
variable "az_a" {
  description = "가용 영역 A"
  type        = string
}



variable "az_c" {
  description = "가용 영역 C"
  type        = string
}

# EC2 관련 설정
variable "ami_id" {
  description = "EC2 인스턴스에 사용할 AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
}

variable "instance_type_be" {
  description = "be EC2 인스턴스 타입"
  type        = string
}


# 태그
variable "project" {
  description = "프로젝트 이름"
  type        = string
}

variable "environment" {
  description = "배포 환경 이름 (예: production)"
  type        = string
}

variable "alb_idle_timeout" {
  description = "ALB의 idle timeout (초)"
  type        = number
}



variable "db_name" {
  description = "RDS DB 이름"
  type        = string
}

variable "db_username" {
  description = "RDS 사용자 이름"
  type        = string
}

variable "db_password" {
  description = "RDS 사용자 비밀번호"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS 인스턴스 타입"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "RDS 스토리지(GB)"
  type        = number
  default     = 20
}

variable "key_pair_name" {
  description = "SSH 접근용 EC2 키페어 이름"
  type        = string
}


# Route53 설정
variable "domain_name" {
  description = "domain name"
  type = string
}

variable "dns_zone_id" {
  description = "zone_id"
  type = string
}

# peering 설정정

variable "shared_vpc_id" {
  description = "shared_vpc_id"
  type = string
}
