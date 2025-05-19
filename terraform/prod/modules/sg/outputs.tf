# output "alb_sg_id" {
#   value = aws_security_group.alb.id
# }

output "frontend_sg_id" {
  value = aws_security_group.frontend.id
}

output "backend_sg_id" {
  value = aws_security_group.backend.id
}

output "sg_alb_frontend_id" {
  value = aws_security_group.alb_frontend.id
}

output "sg_alb_backend_id" {
  value = aws_security_group.alb_backend.id
}

