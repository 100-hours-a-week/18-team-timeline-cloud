output "frontend_a_instance_id" {
  value       = aws_instance.frontend_a.id
  description = "Frontend A 인스턴스 ID"
}


output "backend_a_instance_id" {
  value       = aws_instance.backend_a.id
  description = "Backend A 인스턴스 ID"
}


output "reverse_proxy_public_ip" {
  description = "퍼블릭 서브넷에 있는 리버스 프록시 EC2의 퍼블릭 IP"
  value       = aws_instance.reverse_proxy.public_ip
}


output "backend_a_instance_ip" {
  value       = aws_instance.backend_a.private_ip
  description = "Backend A 인스턴스 ID"
}
