output "public_subnet_a_id" {
  description = "Public Subnet A ID"
  value       = aws_subnet.public_a.id
}

output "public_subnet_c_id" {
  description = "Public Subnet C ID"
  value       = aws_subnet.public_c.id
}

output "private_subnet_a_id" {
  description = "Private Subnet A ID"
  value       = aws_subnet.private_a.id
}

output "private_subnet_c_id" {
  description = "Private Subnet C ID"
  value       = aws_subnet.private_c.id
}
