output "bastion_iam_role_arn" {
    value = aws_iam_role.this.arn
}

output "bastion_public_ip" {
    value = aws_instance.this.public_ip
}