variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
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

variable "enable_bastion" {
  type = bool
  default = false
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
      ami_type = "AL2_x86_64"
    }
  ]
  
  description = "EKS 노드 그룹 설정 리스트"
}
