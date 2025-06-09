# VPC ID
variable "vpc_id" {
  type = string
}

# 퍼블릭 서브넷 리스트 (A, C 등)
variable "public_subnet_ids" {
  type = list(string)
}

# ALB용 보안 그룹 ID
variable "sg_alb_frontend_id" {
  type = string
}

# 프론트 인스턴스 ID 목록 (map 형태, key는 이름, value는 EC2 ID)
variable "frontend_instance_map" {
  description = "Map of frontend EC2 instance IDs"
  type        = map(string)
}
