output "sg_frontend_id" {
  value = aws_security_group.frontend.id
}

output "sg_backend_id" {
  value = aws_security_group.backend.id
}

output "sg_reverse_proxy_id" {
  value = aws_security_group.reverse_proxy.id
}

output "sg_db_id" {
  value = aws_security_group.db.id
}