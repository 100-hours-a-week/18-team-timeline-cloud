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

locals {
  ec2_user_data_backend = <<-EOF
    #!/bin/bash
    set -ex
    until curl -sSf https://aws.amazon.com/ > /dev/null; do
      echo "Waiting for internet connection via NAT Gateway..."
      sleep 3
    done

    # 시스템 업데이트 및 도구 설치
    sudo apt update -y
    sudo apt install -y unzip curl docker.io

    # AWS CLI 설치
    sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    sudo unzip awscliv2.zip
    sudo ./aws/install

    # Docker 데몬 시작 및 부팅 시 자동 실행 설정
    sudo systemctl start docker
    sudo systemctl enable docker

    # Docker 네트워크 생성 (이미 존재하면 스킵)
    sudo docker network inspect tamnara-network >/dev/null 2>&1 || \
    sudo docker network create tamnara-network

    # 로그로 확인
    echo "✅ Docker와 tamnara-network 설정 완료" >> /var/log/user-data.log
  EOF
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
  user_data              = local.ec2_user_data_backend

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
  ami                    = "ami-0c771de2b76d038a1"
  instance_type          = "t3.micro"
  subnet_id              = var.private_subnet_a_db_id
  vpc_security_group_ids = [var.sg_db_id]
  key_name               = var.key_pair_name
  private_ip             = "10.0.30.5" # 프라이빗 IP 고정

  user_data = <<-EOF
#!/bin/bash
echo "🚀 EC2 부팅 후 docker restart 시작: $(date)" >> /home/ubuntu/userdata.log

# Docker 데몬이 확실히 올라오길 기다림 (안정성 보장용)
sleep 5

# MySQL Docker 컨테이너 재시작
sudo docker restart mysql-tamnara >> /home/ubuntu/userdata.log 2>&1

echo "✅ docker restart 완료: $(date)" >> /home/ubuntu/userdata.log
EOF

  tags = {
    Name        = "dev-mysql"
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