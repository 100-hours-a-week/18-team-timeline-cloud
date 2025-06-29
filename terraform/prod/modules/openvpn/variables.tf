variable "name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "sg_openvpn_id" {
  type = string
}

variable "key_pair_name" {
  type = string
}

variable "eip_allocation_id" {
  type = string
}

variable "default_tags" {
  type = map(string)
} 