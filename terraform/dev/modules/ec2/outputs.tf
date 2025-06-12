output "frontend_a_instance_id" {
  value       = aws_instance.frontend_a.id
  description = "Frontend A 인스턴스 ID"
}


output "backend_a_instance_id" {
  value       = aws_instance.backend_a.id
  description = "Backend A 인스턴스 ID"
}
