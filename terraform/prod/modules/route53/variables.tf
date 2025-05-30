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
}

variable "frontend_dns_name" {
  description = "DNS name of the frontend ALB"
  type        = string
}

variable "backend_zone_id" {
  description = "Zone ID of the backend ALB for Route53 alias"
  type        = string
}

variable "backend_dns_name" {
  description = "DNS name of the backend ALB"
  type        = string
}
