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

//ec2 public subnet
variable "public_subnet_a_id" {
  description = "Public Subnet A ID"
  type        = string
}

variable "public_subnet_c_id" {
  description = "Public Subnet A ID"
  type        = string
}


//ec2 fornt subnet
variable "private_subnet_a_front_id" {
  description = "Private Subnet A ID"
  type        = string
}

variable "private_subnet_c_front_id" {
  description = "Private Subnet C ID"
  type        = string
}

//ec2 back subnet
variable "private_subnet_a_back_id" {
  description = "Private Subnet A Back ID"
  type        = string
}
variable "private_subnet_c_back_id" {
  description = "Private Subnet C Back ID"
  type        = string
}


variable "sg_frontend_id" {
  description = "Security group ID for frontend EC2 instances"
  type        = string
}

variable "sg_backend_id" {
  description = "Security group ID for backend EC2 instances"
  type        = string
}

variable "sg_openvpn_id" {
  description = "Security group ID for openvpn EC2 instances"
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

# # EC2 인스턴스가 사용할 IAM 인스턴스 프로파일 이름
# variable "iam_instance_profile_name" {
#   description = "IAM Instance Profile name for ECS EC2 instances"
#   type        = string
# }

# variable "ecs_instance_role_name" {
#   description = "IAM Role name to attach to ECS EC2 instances"
#   type        = string
# }

