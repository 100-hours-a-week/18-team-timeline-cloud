# ECS 클러스터 이름
variable "ecs_cluster_name" {
  type        = string
  description = "ECS 클러스터 이름"
}

# 컨테이너 이름 (ECS Task Definition에 사용)
variable "container_name" {
  type        = string
  description = "컨테이너 이름 (task definition에서 사용)"
}

# 사용할 ECR 이미지 URI
variable "container_image" {
  type        = string
  description = "ECR 이미지 URL (예: 123456789012.dkr.ecr.ap-northeast-2.amazonaws.com/repo:tag)"
}

# 컨테이너 내부에서 expose할 포트
variable "container_port" {
  type        = number
  description = "ECS에서 오픈할 컨테이너 포트"
}

# ECS에서 실행할 task 수
variable "desired_count" {
  type        = number
  default     = 1
}

# ECS Fargate가 배치될 서브넷 리스트
variable "subnet_ids" {
  type = list(string)
}

# ECS에 연결될 보안 그룹 리스트
variable "security_group_ids" {
  type = list(string)
}

# 연결할 ALB의 Target Group ARN
variable "target_group_arn" {
  type = string
}

# Task CPU (단위: vCPU * 1024)
variable "ecs_task_cpu" {
  type    = number
  default = 256
}

variable "ecs_task_memory" {
  type    = number
  default = 256
}
