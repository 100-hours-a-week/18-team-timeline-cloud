# EC2 인스턴스 ID 출력

output "frontend_a_instance_id" {
  value       = aws_instance.frontend_a.id
  description = "Frontend A 인스턴스 ID"
}

output "frontend_c_instance_id" {
  value       = aws_instance.frontend_c.id
  description = "Frontend C 인스턴스 ID"
}

output "backend_a_instance_id" {
  value       = aws_instance.backend_a.id
  description = "Backend A 인스턴스 ID"
}

output "backend_c_instance_id" {
  value       = aws_instance.backend_c.id
  description = "Backend C 인스턴스 ID"
}

