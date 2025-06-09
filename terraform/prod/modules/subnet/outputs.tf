output "public_subnet_a_id" {
  description = "Public Subnet A ID"
  value       = aws_subnet.public_a.id
}

output "public_subnet_c_id" {
  description = "Public Subnet C ID"
  value       = aws_subnet.public_c.id
}

//front subnet
output "private_subnet_a_front_id" {
  description = "Private Subnet A Front ID"
  value       = aws_subnet.private_a_front.id
}

output "private_subnet_c_front_id" {
  description = "Private Subnet C Front ID"
  value       = aws_subnet.private_c_front.id
}


//back subnet
output "private_subnet_a_back_id" {
  description = "Private Subnet A Back ID"
  value       = aws_subnet.private_a_back.id
}

output "private_subnet_c_back_id" {
  description = "Private Subnet C Back ID"
  value       = aws_subnet.private_c_back.id
}


//DB subnet
output "private_subnet_a_db_id" {
  description = "Private Subnet A DB ID"
  value       = aws_subnet.private_a_db.id
}

output "private_subnet_c_db_id" {
  description = "Private Subnet C DB ID"
  value       = aws_subnet.private_c_db.id
}
