# EC2 인스턴스 구성: 프론트엔드 A/C, 백엔드 A/C
# 모두 프라이빗 서브넷에 배치되고, 외부 노출 없음

resource "aws_instance" "frontend_a" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_a_id
  vpc_security_group_ids = [var.sg_frontend_id]

  tags = {
    Name        = "docker-v1-frontend-server-a"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_instance" "frontend_c" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_c_id
  vpc_security_group_ids = [var.sg_frontend_id]

  tags = {
    Name        = "docker-v1-frontend-server-c"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_instance" "backend_a" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_a_id
  vpc_security_group_ids = [var.sg_backend_id]

  tags = {
    Name        = "docker-v1-backend-server-a"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_instance" "backend_c" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_c_id
  vpc_security_group_ids = [var.sg_backend_id]

  tags = {
    Name        = "docker-v1-backend-server-c"
    Project     = var.project
    Environment = var.environment
  }
}


# 프론트엔드 A 연결
resource "aws_lb_target_group_attachment" "frontend_a" {
  target_group_arn = var.tg_frontend_arn
  target_id        = aws_instance.frontend_a.id
  port             = 80
}

# 프론트엔드 C 연결
resource "aws_lb_target_group_attachment" "frontend_c" {
  target_group_arn = var.tg_frontend_arn
  target_id        = aws_instance.frontend_c.id
  port             = 80
}

# 백엔드 A 연결
resource "aws_lb_target_group_attachment" "backend_a" {
  target_group_arn = var.tg_backend_arn
  target_id        = aws_instance.backend_a.id
  port             = 8080
}

# 백엔드 C 연결
resource "aws_lb_target_group_attachment" "backend_c" {
  target_group_arn = var.tg_backend_arn
  target_id        = aws_instance.backend_c.id
  port             = 8080
}
