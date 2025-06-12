# ─────────────────────────────────────────────────────
# Frontend EC2 Instances
# ─────────────────────────────────────────────────────
resource "aws_instance" "frontend_a" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_a_front_id
  vpc_security_group_ids = [var.sg_frontend_id]
  key_name               = var.key_pair_name

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
