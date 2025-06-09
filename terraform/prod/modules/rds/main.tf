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
    security_groups = [var.backend_sg_id] # 백엔드 SG로부터만 허용
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
  identifier              = "${var.project}-${var.environment}-rds"
  instance_class          = var.db_instance_class
  snapshot_identifier     = "prod-rds-0528" 
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

