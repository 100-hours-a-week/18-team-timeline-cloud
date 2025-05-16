output "alb_dns_name" {
  description = "ALB DNS 이름"
  value       = aws_lb.this.dns_name
}

output "alb_target_group_frontend" {
  value       = aws_lb_target_group.frontend.arn
  description = "프론트엔드 Target Group ARN"
}

output "alb_target_group_backend" {
  value       = aws_lb_target_group.backend.arn
  description = "백엔드 Target Group ARN"
}
