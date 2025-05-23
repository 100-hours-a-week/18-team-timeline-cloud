# resource "aws_security_group" "alb" {
#   name        = "alb-sg"
#   description = "Allow HTTP from anywhere to ALB"
#   vpc_id      = var.vpc_id

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = { Name = "alb-sg" }
# }

resource "aws_security_group" "alb_frontend" {
  name        = "docker-v1-sg-alb-frontend"
  description = "Allow HTTP from internet to frontend ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 퍼블릭
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "alb-frontend-sg" }
}

resource "aws_security_group" "alb_backend" {
  name        = "docker-v1-sg-alb-backend"
  description = "Allow internal ALB traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # 내부 ALB일 경우 내부만 허용
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "alb-backend-sg" }
}


# resource "aws_security_group" "frontend" {
#   name        = "frontend-sg"  # ✅ sg- 제거
#   description = "Allow from ALB"
#   vpc_id      = var.vpc_id

#   ingress {
#     from_port       = 80
#     to_port         = 80
#     protocol        = "tcp"
#     security_groups = [aws_security_group.alb.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = { Name = "frontend-sg" }
# }

resource "aws_security_group" "frontend" {
  name        = "docker-v1-sg-frontend"
  description = "Allow from ALB (frontend)"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_frontend.id]  # ✅ 수정!
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "frontend-sg" }
}


# resource "aws_security_group" "backend" {
#   name        = "backend-sg"  # ✅ sg- 제거
#   description = "Allow from ALB"
#   vpc_id      = var.vpc_id

#   ingress {
#     from_port       = 8080
#     to_port         = 8080
#     protocol        = "tcp"
#     security_groups = [aws_security_group.alb.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = { Name = "backend-sg" }
# }


resource "aws_security_group" "backend" {
  name        = "docker-v1-sg-backend"
  description = "Allow from ALB (backend)"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_backend.id]  # ✅ 수정!
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "backend-sg" }
}
