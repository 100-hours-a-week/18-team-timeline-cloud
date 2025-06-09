# VPC ID
variable "vpc_id" {
  type = string
}

# 프라이빗 서브넷 리스트 (A, C 등)
variable "private_subnet_ids" {
  type = list(string)
}

# 백엔드 ALB용 보안 그룹 ID
variable "sg_alb_backend_id" {
  type = string
}

# 백엔드 인스턴스 ID map (key는 이름, value는 EC2 ID)
variable "backend_instance_map" {
  description = "Map of backend EC2 instance IDs"
  type        = map(string)
}
