resource "aws_db_subnet_group" "this" {
  name       = "${var.project}-${var.environment}-db-subnet-group"
  subnet_ids =  [var.private_subnet_a_db_id, var.private_subnet_c_db_id]

  tags = {
    Name = "${var.project}-${var.environment}-db-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.project}-${var.environment}-rds-sg"
  description = "Allow MySQL from backend SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.backend_sg_id] # 백엔드 SG로부터 허용
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.eks_cluster_sg_id] # EKS 클러스터 SG로부터 허용 (ArgoCD Pod들)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.environment}-rds-sg"
  }
}

resource "aws_db_instance" "this" {
  identifier              = "${var.project}-prod-rds"
  instance_class          = var.db_instance_class
  
  # 스냅샷이 있으면 스냅샷에서 복원, 없으면 새로 생성
  snapshot_identifier     = var.db_snapshot_identifier
  
  # 스냅샷이 없을 때만 DB 생성 옵션들 사용
  allocated_storage       = var.db_snapshot_identifier == null ? var.db_allocated_storage : null
  engine                  = var.db_snapshot_identifier == null ? "mysql" : null
  engine_version          = var.db_snapshot_identifier == null ? "8.0" : null
  db_name                 = var.db_snapshot_identifier == null ? var.db_name : null
  username                = var.db_snapshot_identifier == null ? var.db_username : null
  
  # 민감한 값은 조건부 표현식을 사용하지 않고 항상 설정
  # 스냅샷에서 복원할 때는 기존 비밀번호를 유지하고, 새로 생성할 때는 새 비밀번호 사용
  password                = var.db_password
  
  port                    = 3306
  multi_az                = false
  storage_encrypted       = false
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.rds.id]
  db_subnet_group_name    = aws_db_subnet_group.this.name
  skip_final_snapshot     = true

  tags = {
    Name = "${var.project}-${var.environment}-rds"
  }
}

