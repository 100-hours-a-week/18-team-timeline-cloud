variable "vpc_id" {
  type = string
}

variable "private_subnet_a_db_id" {
  description = "Private Subnet A DB ID"
  type        = string
}

variable "private_subnet_c_db_id" {
  description = "Private Subnet C DB ID"
  type        = string
}


variable "backend_sg_id" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
  sensitive = true
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "db_snapshot_identifier" {
  description = "DB snapshot identifier to restore from (optional)"
  type        = string
  default     = null
}
