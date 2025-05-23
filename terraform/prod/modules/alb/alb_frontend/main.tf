# 프론트엔드 ALB 생성
resource "aws_lb" "docker-v1-frontend-alb" {
  name               = "docker-v1-frontend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_alb_frontend_id]
  subnets            = var.public_subnet_ids
}

# 프론트엔드용 Target Group 생성
resource "aws_lb_target_group" "docker-v1-frontend-tg" {
  name        = "docker-v1-tg-frontend"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"  # 프론트엔드의 기본 경로로 헬스 체크
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# 프론트엔드 리스너 (포트 80 수신)
resource "aws_lb_listener" "docker-v1-frontend-listener" {
  load_balancer_arn = aws_lb.docker-v1-frontend-alb.arn  # ✅ 리소스 이름에 맞게 수정
  port              = 443
  protocol          = "HTTPS"

  certificate_arn = "arn:aws:acm:ap-northeast-2:346011888304:certificate/5148a950-7ad3-449d-ab32-4d4545a692ff"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.docker-v1-frontend-tg.arn  # ✅ 수정
  }
}

# 프론트 인스턴스들을 Target Group에 연결 (map 기반 for_each)
resource "aws_lb_target_group_attachment" "docker-v1-frontend-attachment" {
  for_each         = var.frontend_instance_map
  target_group_arn = aws_lb_target_group.docker-v1-frontend-tg.arn  # ✅ 수정
  target_id        = each.value
  port             = 80
}
