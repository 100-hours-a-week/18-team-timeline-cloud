variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
  default = "ap-northeast-2"
}

variable "key_name" {
  type = string
}

variable "bastion_instance_type" {
  type = string
  default = "t3.medium"
}

variable "enable_bastion" {
  type = bool
  default = false
}

variable "node_iam_role_arns" {
  type = list(string)
}

variable "default_tags" {
  type = map(string)
} 