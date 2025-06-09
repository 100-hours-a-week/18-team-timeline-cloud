output "frontend_alb_dns_name" {
  value = aws_lb.docker-v1-frontend-alb.dns_name
}

output "frontend_target_group_arn" {
  value = aws_lb_target_group.docker-v1-frontend-tg.arn
}

output "zone_id" {
  value = aws_lb.docker-v1-frontend-alb.zone_id
}
