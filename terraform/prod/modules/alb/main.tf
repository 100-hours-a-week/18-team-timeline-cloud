# ALB 생성
resource "aws_lb" "this" {
  name               = "docker-v1-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_alb_id]
  subnets            = [var.public_subnet_a_id, var.public_subnet_c_id]

  tags = {
    Name = "docker-v1-alb"
  }
}

# 프론트 Target Group (기본 경로 처리용)
resource "aws_lb_target_group" "frontend" {
  name     = "tg-frontend"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "tg-frontend"
  }
}

# 백엔드 Target Group (/api용)
resource "aws_lb_target_group" "backend" {
  name     = "tg-backend"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/actuator/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "tg-backend"
  }
}

# HTTP 리스너 생성
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

# 경로 기반 라우팅 설정 (/api → 백엔드)
resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}
