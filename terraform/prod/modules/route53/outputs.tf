output "frontend_domain_name" {
  description = "Frontend Domain Name"
  value       = aws_route53_record.frontend_alb_record.name
}

output "backend_domain_name" {
  description = "Backend Domain Name"
  value       = aws_route53_record.backend_alb_record.name
}
