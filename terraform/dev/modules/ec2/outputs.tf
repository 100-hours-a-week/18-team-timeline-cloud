output "frontend_instance_id" {
  description = "Frontend EC2 Instance ID"
  value       = aws_instance.frontend.id
}

output "backend_instance_id" {
  description = "Backend EC2 Instance ID"
  value       = aws_instance.backend.id
}

output "db_instance_id" {
  description = "DB EC2 Instance ID"
  value       = aws_instance.db.id
}

output "frontend_instance_ip" {
  description = "Frontend EC2 Instance Private IP"
  value       = aws_instance.frontend.private_ip
}

output "backend_instance_ip" {
  description = "Backend EC2 Instance Private IP"
  value       = aws_instance.backend.private_ip
}

output "db_instance_ip" {
  description = "DB EC2 Instance Private IP"
  value       = aws_instance.db.private_ip
}

output "reverse_proxy_public_ip" {
  description = "퍼블릭 서브넷에 있는 리버스 프록시 EC2의 퍼블릭 IP"
  value       = aws_instance.reverse_proxy.public_ip
}
