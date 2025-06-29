output "openvpn_instance_id" {
  value       = aws_instance.openvpn.id
  description = "OpenVPN 인스턴스 ID"
}

output "openvpn_public_ip" {
  value       = aws_instance.openvpn.public_ip
  description = "OpenVPN 인스턴스 퍼블릭 IP"
}

output "openvpn_private_ip" {
  value       = aws_instance.openvpn.private_ip
  description = "OpenVPN 인스턴스 프라이빗 IP"
} 