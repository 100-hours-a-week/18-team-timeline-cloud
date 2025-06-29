# ─────────────────────────────────────────────────────
# OpenVPN EC2 + EIP
# ─────────────────────────────────────────────────────
resource "aws_instance" "openvpn" {
  ami                    = "ami-0c4d94bb44eff8915"
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.sg_openvpn_id]
  key_name               = var.key_pair_name

  tags = merge(var.default_tags, {
    Name = "${var.name}-openvpn-server"
  })
}

resource "aws_eip_association" "openvpn" {
  instance_id   = aws_instance.openvpn.id
  allocation_id = var.eip_allocation_id
} 