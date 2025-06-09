# modules/ecs/main.tf (수정 버전)

# ✅ ECS 클러스터 생성
resource "aws_ecs_cluster" "this" {
  name = var.ecs_cluster_name
}

# ✅ ECS 태스크 실행 IAM 역할 (ECS에서 이미지 풀 및 로그 기록 가능해야 함)
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.ecs_cluster_name}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.ecs_cluster_name}"
  retention_in_days = 7
}


# ✅ ECS 태스크 정의
resource "aws_ecs_task_definition" "this" {
  family                   = var.ecs_cluster_name
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  depends_on = [aws_cloudwatch_log_group.ecs]
  
container_definitions = jsonencode([
  {
    name      = var.container_name,
    image     = var.container_image,
    cpu       = 0,
    memory    = var.ecs_task_memory,
    essential = true,
    portMappings = [
      {
        containerPort = var.container_port
        hostPort      = var.container_port
      }
    ],
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        awslogs-group         = "/ecs/${var.ecs_cluster_name}"
        awslogs-region        = "ap-northeast-2"
        awslogs-stream-prefix = var.container_name
      }
    }
  }
])

}

# ✅ ECS 서비스
resource "aws_ecs_service" "this" {
  name            = "${var.ecs_cluster_name}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "EC2"

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  # network_configuration {
  #   subnets          = var.subnet_ids
  #   security_groups  = var.security_group_ids
  #   assign_public_ip = false
  # }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_policy]
}


