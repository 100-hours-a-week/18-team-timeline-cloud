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

variable "db_snapshot_identifier" {
  description = "복원할 DB 스냅샷 식별자 (선택사항 - 설정하지 않으면 새 DB 생성)"
  type        = string
  default     = null
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

# peering vpc id
variable "peering_vpc_id" {
  description = "peering_vpc_id"
  type = string
}

# ArgoCD 설정
variable "enable_argocd" {
  description = "Enable ArgoCD"
  type        = bool
  default     = false
}

variable "argocd_safe_destroy" {
  description = "Enable safe destroy mode for ArgoCD (disable before destroy)"
  type        = bool
  default     = false
}

variable "argocd_chart_version" {
  description = "Version of ArgoCD Helm chart"
  type        = string
  default     = "7.7.8"
}

variable "enable_app_of_apps" {
  description = "Enable App of Apps pattern - automatically deploy root application"
  type        = bool
  default     = true
}

variable "repo_url" {
  description = "Git repository URL for ArgoCD applications"
  type        = string
  default     = "https://github.com/chang18-cloud/18-team-timeline-cloud"
}

variable "target_revision" {
  description = "Git branch/tag/commit for ArgoCD to track"
  type        = string
  default     = "HEAD"
}

variable "applications_path" {
  description = "Path in git repo where ArgoCD applications are stored"
  type        = string
  default     = "argocd/applications"
}

# External-DNS 설정
variable "enable_external_dns" {
  description = "Enable External-DNS"
  type        = bool
  default     = true
}

variable "domain_filters" {
  description = "List of domains to filter for External-DNS"
  type        = list(string)
  default     = []
}


# variable "dev_ami_id" {
#   description = "AMI ID for dev EC2"
#   type        = string
# }

# variable "dev_instance_type" {
#   description = "Instance type for dev EC2"
#   type        = string
# }

# variable "dev_key_pair_name" {
#   description = "Key pair name for dev EC2"
#   type        = string
# }

# Private IP 설정
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

