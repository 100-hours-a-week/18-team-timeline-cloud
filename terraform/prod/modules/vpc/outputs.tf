output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC ID"
}

output "igw_id" {
  value       = aws_internet_gateway.igw.id
  description = "인터넷 게이트웨이 ID"
}

output "public_route_table_id" {
  value       = aws_route_table.public.id
  description = "퍼블릭 라우팅 테이블 ID"
}
