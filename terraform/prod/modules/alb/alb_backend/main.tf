# 백엔드 ALB 생성 (internal ALB)
resource "aws_lb" "docker-v1-backend-alb" {
  name               = "docker-v1-backend-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.sg_alb_backend_id]
  subnets            = var.private_subnet_ids
}

# 백엔드 Target Group 생성
resource "aws_lb_target_group" "docker-v1-backend-tg" {
  name        = "docker-v1-tg-backend"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/actuator/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# 백엔드 리스너 (포트 80 수신)
resource "aws_lb_listener" "docker-v1-backend-listener" {
  load_balancer_arn = aws_lb.docker-v1-backend-alb.arn  # ✅ 변경
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.docker-v1-backend-tg.arn  # ✅ 변경
  }
}

# 백엔드 인스턴스들을 Target Group에 연결
resource "aws_lb_target_group_attachment" "docker-v1-backend-attachment" {
  for_each         = var.backend_instance_map
  target_group_arn = aws_lb_target_group.docker-v1-backend-tg.arn  # ✅ 변경
  target_id        = each.value
  port             = 8080
}
