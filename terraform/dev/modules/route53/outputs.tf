output "frontend_domain_name" {
  description = "Frontend Domain Name"
  value       = length(aws_route53_record.frontend_alb_record) > 0 ? aws_route53_record.frontend_alb_record[0].name : null
}

output "backend_domain_name" {
  description = "Backend Domain Name"
  value       = length(aws_route53_record.backend_alb_record) > 0 ? aws_route53_record.backend_alb_record[0].name : null
}
