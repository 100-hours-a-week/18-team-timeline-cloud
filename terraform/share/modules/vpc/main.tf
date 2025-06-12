# VPC 생성
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "docker-v1-vpc"
  }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "docker-v1-igw"
  }
}

# 퍼블릭 라우팅 테이블 생성
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "docker-v1-publicRT"
  }
}

# 퍼블릭 라우팅 테이블을 퍼블릭 서브넷 A에 연결
resource "aws_route_table_association" "public_a" {
  subnet_id      = var.public_subnet_a_id
  route_table_id = aws_route_table.public.id
}

# 퍼블릭 라우팅 테이블을 퍼블릭 서브넷 C에 연결
resource "aws_route_table_association" "public_c" {
  subnet_id      = var.public_subnet_c_id
  route_table_id = aws_route_table.public.id
}
