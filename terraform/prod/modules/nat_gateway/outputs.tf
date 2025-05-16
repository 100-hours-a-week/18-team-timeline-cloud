output "nat_gateway_id" {
  value       = aws_nat_gateway.this.id
  description = "NAT Gateway ID"
}

output "private_route_table_id" {
  value       = aws_route_table.private.id
  description = "프라이빗 서브넷용 라우팅 테이블 ID"
}

# output "x" {
#   value       = aws_security_group.alb.id
#   description = "ALB 보안 그룹 ID"
# }
