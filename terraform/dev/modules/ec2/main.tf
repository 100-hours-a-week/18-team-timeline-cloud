# ─────────────────────────────────────────────────────
# Frontend EC2 Instances
# ─────────────────────────────────────────────────────
resource "aws_instance" "frontend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_a_front_id
  private_ip             = var.front_private_ip
  vpc_security_group_ids = [var.sg_frontend_id]
  key_name               = var.key_pair_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  user_data              = local.ec2_user_data_frontend
  tags = {
    Name        = "docker-v1-frontend-server-a-dev"
    Project     = var.project
    Environment = var.environment
  }
}


# ─────────────────────────────────────────────────────
# Backend EC2 Instances
# ─────────────────────────────────────────────────────
resource "aws_instance" "backend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_be
  subnet_id              = var.private_subnet_a_back_id
  private_ip             = var.backend_private_ip
  vpc_security_group_ids = [var.sg_backend_id]
  key_name               = var.key_pair_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  user_data              = local.ec2_user_data_backend

  tags = {
    Name        = "docker-v1-backend-server-a-dev"
    Project     = var.project
    Environment = var.environment
  }
}

locals {
  ec2_user_data_frontend = <<-EOF
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
 
  EOF
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
# MySQL EC2 Instance (mySQL 서버)
# ─────────────────────────────────────────────────────

resource "aws_instance" "db" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_a_db_id
  private_ip             = var.db_private_ip
  vpc_security_group_ids = [var.sg_db_id]
  key_name               = var.key_pair_name

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
  ami                         = "ami-099db85e6386757a5"
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_a_id 
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_reverse_proxy_id]
  key_name                    = var.key_pair_name

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nginx
              sudo apt install -y software-properties-common
              sudo add-apt-repository universe -y
              sudo add-apt-repository ppa:certbot/certbot -y
              sudo apt update
              sudo apt install -y certbot python3-certbot-nginx

              sudo bash -c 'cat > /etc/nginx/sites-available/default <<CONFIG
              server {
                  listen 80;
                  server_name dev.tam-nara.com;

                  location / {
                      proxy_pass http://${aws_instance.frontend.private_ip}:3000;
                      proxy_set_header Host \$host;
                      proxy_set_header X-Real-IP \$remote_addr;
                      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                      proxy_set_header X-Forwarded-Proto \$scheme;
                  }
              }

              server {
                  listen 80;
                  server_name dev.api.tam-nara.com;

                  location / {
                      proxy_pass http://${aws_instance.backend.private_ip}:8080;
                      proxy_set_header Host \$host;
                      proxy_set_header X-Real-IP \$remote_addr;
                      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                      proxy_set_header X-Forwarded-Proto \$scheme;
                  }
              }
              CONFIG'

              sudo systemctl restart nginx

              # 1분 대기 후 Certbot으로 SSL 인증서 발급 (80 포트 필요)
              sleep 60

              sudo certbot --nginx --non-interactive --agree-tos --email you@example.com \
                -d dev.tam-nara.com -d dev.api.tam-nara.com

              # cron 등록 (자동 갱신)
              (crontab -l 2>/dev/null; echo "0 3 * * * /usr/bin/certbot renew --quiet") | crontab -

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