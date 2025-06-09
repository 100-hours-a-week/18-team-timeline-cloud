# EIP 생성 (NAT용)
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "docker-v1-nat-eip"
  }
}

# NAT Gateway 생성 (Public Subnet A)
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_a_id

  tags = {
    Name = "docker-v1-natgw"
  }

  depends_on = [aws_eip.nat]
}

# Private Route Table 생성
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "docker-v1-privateRT"
  }
}

# Private Subnet Front A에 라우팅 테이블 연결
 resource "aws_route_table_association" "private_a_front" {
  subnet_id      = var.private_subnet_a_front_id
  route_table_id = aws_route_table.private.id
}

# Private Subnet Front C에 라우팅 테이블 연결
resource "aws_route_table_association" "private_c_front" {
  subnet_id      = var.private_subnet_c_front_id
  route_table_id = aws_route_table.private.id
}

# Private Subnet Back A에 라우팅 테이블 연결
resource "aws_route_table_association" "private_a_back" {
  subnet_id      = var.private_subnet_a_back_id
  route_table_id = aws_route_table.private.id
}

# Private Subnet Back C에 라우팅 테이블 연결
resource "aws_route_table_association" "private_c_back" {
  subnet_id      = var.private_subnet_c_back_id
  route_table_id = aws_route_table.private.id
}

