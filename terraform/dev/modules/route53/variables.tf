variable "hosted_zone_id" {
  description = "Route53 Hosted Zone ID for the domain"
  type        = string
}

variable "domain_name" {
  description = "Root domain name for the records (e.g., example.com)"
  type        = string
}

variable "frontend_zone_id" {
  description = "Zone ID of the frontend ALB for Route53 alias"
  type        = string
  default     = null
}

variable "frontend_dns_name" {
  description = "DNS name of the frontend ALB"
  type        = string
  default     = null
}

variable "backend_zone_id" {
  description = "Zone ID of the backend ALB for Route53 alias"
  type        = string
  default     = null
}

variable "backend_dns_name" {
  description = "DNS name of the backend ALB"
  type        = string
  default     = null
}

variable "proxy_ec2_ip" {
  description = "퍼블릭 프록시 EC2 인스턴스의 퍼블릭 IP"
  type        = string
}

variable "back_ec2_ip" {
  description = "백엔드 EC2 인스턴스의 프라이빗 IP"
  type        = string
}

