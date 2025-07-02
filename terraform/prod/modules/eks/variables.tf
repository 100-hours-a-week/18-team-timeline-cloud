variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "region" {
  type = string
  default = "ap-northeast-2"
}

variable "kubernetes_version" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "cluster_enabled_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "disk_size" {
  type    = number
  default = 30
}

variable "node_groups" {
  type = list(object({
    name = string
    subnet_ids = list(string)
    instance_types = list(string)
    disk_size = number
    desired_size = number
    max_size = number
    min_size = number
    capacity_type = string
    ami_type = string
  }))
  
  default = [
    {
      name = "default"
      subnet_ids = []
      instance_types = ["t3.medium"]
      disk_size = 30
      desired_size = 2
      max_size = 6
      min_size = 1
      capacity_type = "ON_DEMAND"
      ami_type = "AL2023_x86_64_STANDARD"
    }
  ]
  
  description = "EKS 노드 그룹 설정 리스트"
}

variable "project" {
  description = "프로젝트 이름"
  type        = string
}

variable "environment" {
  description = "환경 (예: dev, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
}
