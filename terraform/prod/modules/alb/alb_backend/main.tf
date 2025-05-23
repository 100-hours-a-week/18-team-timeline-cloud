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
  protocol    = "HTTPS"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
  path                = "/health"
  interval            = 60
  timeout             = 10
  healthy_threshold   = 3
  unhealthy_threshold = 10
  matcher             = "200"
}

}

# 백엔드 리스너 (포트 80 수신)
resource "aws_lb_listener" "docker-v1-backend-listener" {
  load_balancer_arn = aws_lb.docker-v1-backend-alb.arn  # ✅ 변경
  port              = 443
  protocol          = "HTTPS"

  certificate_arn = "arn:aws:acm:ap-northeast-2:346011888304:certificate/607757da-9b4e-40e0-8230-20c01b4ac547"

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
