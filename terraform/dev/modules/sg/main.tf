# ─────────────────────────────────────────────────────
# Reverse Proxy 보안 그룹 (퍼블릭 EC2용)
# ─────────────────────────────────────────────────────
resource "aws_security_group" "reverse_proxy" {
  name        = "docker-v1-sg-reverse-proxy-dev"
  description = "Allow HTTP/SSH from Internet"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH from YOUR IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 보안을 위해 제한
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "reverse-proxy-sg" }
}


# ─────────────────────────────────────────────────────
# 프론트엔드 보안 그룹 (3000포트, 프록시에서만 허용)
# ─────────────────────────────────────────────────────
resource "aws_security_group" "frontend" {
  name        = "docker-v1-sg-frontend-dev"
  description = "Allow from Reverse Proxy"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.reverse_proxy.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.255.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "dev-frontend-sg" }
}


# ─────────────────────────────────────────────────────
# 백엔드 보안 그룹 (8080포트, 프록시에서만 허용)
# ─────────────────────────────────────────────────────
resource "aws_security_group" "backend" {
  name        = "docker-v1-sg-backend-dev"
  description = "Allow from Reverse Proxy"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.255.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "dev-backend-sg" }
}

# ─────────────────────────────────────────────────────
# MySQL 보안 그룹 (SSH,3306포트, 내부 네트워크에서만 허용)
# ─────────────────────────────────────────────────────
resource "aws_security_group" "db" {
  name        = "docker-v1-sg-db-dev"
  description = "Allow MySQL access from internal network"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # 내부 SSH
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.backend.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev-mysql-sg"
  }
}