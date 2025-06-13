# ─────────────────────────────────────────────────────
# Frontend EC2 Instances
# ─────────────────────────────────────────────────────
resource "aws_instance" "frontend_a" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_a_front_id
  vpc_security_group_ids = [var.sg_frontend_id]
  key_name               = var.key_pair_name
  private_ip             = "10.0.10.5" # 프라이빗 Ip 고정
  tags = {
    Name        = "docker-v1-frontend-server-a-dev"
    Project     = var.project
    Environment = var.environment
  }
}


# ─────────────────────────────────────────────────────
# Backend EC2 Instances
# ─────────────────────────────────────────────────────
resource "aws_instance" "backend_a" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_be
  subnet_id              = var.private_subnet_a_back_id
  vpc_security_group_ids = [var.sg_backend_id]
  key_name               = var.key_pair_name
  private_ip             = "10.0.20.5"   #프라이빗 Ip 고정
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name

  tags = {
    Name        = "docker-v1-backend-server-a-dev"
    Project     = var.project
    Environment = var.environment
  }
}

# ─────────────────────────────────────────────────────
# MySQL EC2 Instance (mySQL 서버)
# ─────────────────────────────────────────────────────

resource "aws_instance" "mysql" {
  ami                    = "ami-06097435277f6d1a5"
  instance_type          = "t3.micro"
  subnet_id              = var.private_subnet_a_db_id
  vpc_security_group_ids = [var.sg_db_id]
  key_name               = var.key_pair_name
  private_ip             = "10.0.30.5" # 프라이빗 Ip 고정

  tags = {
    Name = "dev-mysql"
    Project     = var.project
    Environment = var.environment
  }
}


# ─────────────────────────────────────────────────────
# Reverse Proxy EC2 Instance (Public Subnet)
# ─────────────────────────────────────────────────────
resource "aws_instance" "reverse_proxy" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_a_id 
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_reverse_proxy_id]
  key_name                    = var.key_pair_name

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y nginx

              sudo bash -c 'cat > /etc/nginx/sites-available/default <<CONFIG
              server {
                  listen 80;

                  location /front/ {
                      proxy_pass http://${aws_instance.frontend_a.private_ip}:3000/;
                      proxy_set_header Host \$host;
                      proxy_set_header X-Real-IP \$remote_addr;
                      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                      proxy_set_header X-Forwarded-Proto \$scheme;
                  }

                  location /back/ {
                      proxy_pass http://${aws_instance.backend_a.private_ip}:8080/;
                      proxy_set_header Host \$host;
                      proxy_set_header X-Real-IP \$remote_addr;
                      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                      proxy_set_header X-Forwarded-Proto \$scheme;
                  }
              }
              CONFIG'

              sudo systemctl restart nginx
              EOF

  tags = {
    Name        = "reverse-proxy-dev"
    Project     = var.project
    Environment = var.environment
  }
}


# ─────────────────────────────────────────────────────
# IAM Role for EC2 Instances to connect to ECR
# ─────────────────────────────────────────────────────
resource "aws_iam_role" "ec2_instance_role" {
  name = "ec2-instance-role-for-ecr"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# EC2가 ECR에서 이미지 Pull할 수 있도록 권한 부여
resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# EC2가 ECS Agent도 실행할 경우 이 정책도 같이 부여
resource "aws_iam_role_policy_attachment" "ecs_instance_policy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# EC2 Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile-for-ecr"
  role = aws_iam_role.ec2_instance_role.name
}