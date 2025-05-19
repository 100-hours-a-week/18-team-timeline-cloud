# EC2 인스턴스 생성 시 사용할 AMI ID
variable "ami_id" {
  description = "EC2 인스턴스에 사용할 AMI ID"
  type        = string
}

# EC2 인스턴스 타입 (예: t3.micro)
variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
}

# EC2 인스턴스가 배치될 프라이빗 서브넷 ID (A, C)
variable "private_subnet_a_id" {
  description = "AZ A의 프라이빗 서브넷 ID"
  type        = string
}

variable "private_subnet_c_id" {
  description = "AZ C의 프라이빗 서브넷 ID"
  type        = string
}

# 보안 그룹 ID (sg 모듈에서 받아옴)
variable "sg_frontend_id" {
  description = "프론트엔드 서버용 보안 그룹 ID"
  type        = string
}

variable "sg_backend_id" {
  description = "백엔드 서버용 보안 그룹 ID"
  type        = string
}

# 공통 태그 정보
variable "project" {
  description = "프로젝트 이름 (태그용)"
  type        = string
}

variable "environment" {
  description = "배포 환경 이름 (예: production)"
  type        = string
}

variable "tg_frontend_arn" {
  description = "프론트엔드용 Target Group ARN"
  type        = string
}

variable "tg_backend_arn" {
  description = "백엔드용 Target Group ARN"
  type        = string
}
