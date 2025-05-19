output "backend_alb_dns_name" {
  value = aws_lb.docker-v1-backend-alb.dns_name
}

output "backend_target_group_arn" {
  value = aws_lb_target_group.docker-v1-backend-tg.arn
}
