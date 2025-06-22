# ─────────────────────────────────────────────────────
# IAM Role for ECS EC2 Instances
# ─────────────────────────────────────────────────────
resource "aws_iam_role" "ecs_instance_role" {
  name = "ecsInstanceRole"

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

resource "aws_iam_role_policy_attachment" "ecs_instance_policy" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance" {
  name = "ecsInstanceProfile"
  role = aws_iam_role.ecs_instance_role.name
}

# ─────────────────────────────────────────────────────
# User Data - 프론트엔드용 ECS Agent 설정
# ─────────────────────────────────────────────────────
locals {
  ecs_user_data_frontend = <<-EOF
    #!/bin/bash
    set -ex
    until curl -sSf https://aws.amazon.com/ > /dev/null; do
      echo "Waiting for internet connection via NAT Gateway..."
      sleep 3
    done
    
    sudo apt-get update -y
    sudo apt-get install -y docker.io curl unzip awscli python3 netfilter-persistent

    sudo systemctl enable docker
    sudo systemctl start docker

    sudo usermod -a -G docker ubuntu

    # Install CloudWatch Logs agent
    wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
    sudo dpkg -i -E ./amazon-cloudwatch-agent.deb

    mkdir -p /etc/ecs
    mkdir -p /var/log/ecs
    mkdir -p /var/lib/ecs/data
    
    sysctl -w net.ipv4.conf.all.route_localnet=1
    iptables -t nat -A PREROUTING -p tcp -d 169.254.170.2 --dport 80 -j DNAT --to-destination 127.0.0.1:51679
    iptables -t nat -A OUTPUT -d 169.254.170.2 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 51679
    netfilter-persistent save

    # ECS Agent Configuration
    echo "ECS_CLUSTER=docker-v1-frontend-cluster" > /etc/ecs/ecs.config
    echo "ECS_AVAILABLE_LOGGING_DRIVERS=[\"json-file\",\"awslogs\",\"syslog\",\"none\"]" >> /etc/ecs/ecs.config
    echo "ECS_ENABLE_TASK_IAM_ROLE=true" >> /etc/ecs/ecs.config
    echo "ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true" >> /etc/ecs/ecs.config
    echo "ECS_ENABLE_AWSLOGS_EXECUTIONROLE_OVERRIDE=true" >> /etc/ecs/ecs.config
    echo "ECS_ENABLE_CONTAINER_METADATA=true" >> /etc/ecs/ecs.config
    echo "ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=1h" >> /etc/ecs/ecs.config

    docker run --name ecs-agent \
      --detach=true \
      --restart=always \
      --volume=/var/run/docker.sock:/var/run/docker.sock \
      --volume=/var/log/ecs:/log \
      --volume=/var/lib/ecs/data:/data \
      --volume=/etc/ecs:/etc/ecs \
      --net=host \
      --env-file=/etc/ecs/ecs.config \
      amazon/amazon-ecs-agent:latest
  EOF
}

# ─────────────────────────────────────────────────────
# User Data - 백엔드용 ECS Agent 설정
# ─────────────────────────────────────────────────────
locals {
  ecs_user_data_backend = <<-EOF
    #!/bin/bash
    set -ex
    until curl -sSf https://aws.amazon.com/ > /dev/null; do
      echo "Waiting for internet connection via NAT Gateway..."
      sleep 3
    done
    
    sudo apt-get update -y
    sudo apt install mysql-client -y
    sudo apt-get install -y docker.io curl unzip awscli python3 netfilter-persistent

    sudo systemctl enable docker
    sudo systemctl start docker

    sudo usermod -a -G docker ubuntu

    # Install CloudWatch Logs agent
    wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
    sudo dpkg -i -E ./amazon-cloudwatch-agent.deb

    mkdir -p /etc/ecs
    mkdir -p /var/log/ecs
    mkdir -p /var/lib/ecs/data
    
    sysctl -w net.ipv4.conf.all.route_localnet=1
    iptables -t nat -A PREROUTING -p tcp -d 169.254.170.2 --dport 80 -j DNAT --to-destination 127.0.0.1:51679
    iptables -t nat -A OUTPUT -d 169.254.170.2 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 51679
    netfilter-persistent save

    # ECS Agent Configuration
    echo "ECS_CLUSTER=docker-v1-backend-cluster" > /etc/ecs/ecs.config
    echo "ECS_AVAILABLE_LOGGING_DRIVERS=[\"json-file\",\"awslogs\",\"syslog\",\"none\"]" >> /etc/ecs/ecs.config
    echo "ECS_ENABLE_TASK_IAM_ROLE=true" >> /etc/ecs/ecs.config
    echo "ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true" >> /etc/ecs/ecs.config
    echo "ECS_ENABLE_AWSLOGS_EXECUTIONROLE_OVERRIDE=true" >> /etc/ecs/ecs.config
    echo "ECS_ENABLE_CONTAINER_METADATA=true" >> /etc/ecs/ecs.config
    echo "ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=1h" >> /etc/ecs/ecs.config

    docker run --name ecs-agent \
      --detach=true \
      --restart=always \
      --volume=/var/run/docker.sock:/var/run/docker.sock \
      --volume=/var/log/ecs:/log \
      --volume=/var/lib/ecs/data:/data \
      --volume=/etc/ecs:/etc/ecs \
      --net=host \
      --env-file=/etc/ecs/ecs.config \
      amazon/amazon-ecs-agent:latest
  EOF
}

# ─────────────────────────────────────────────────────
# Frontend EC2 Instances
# ─────────────────────────────────────────────────────
resource "aws_instance" "frontend_a" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_a_front_id
  vpc_security_group_ids = [var.sg_frontend_id]
  key_name               = var.key_pair_name
  iam_instance_profile   = aws_iam_instance_profile.ecs_instance.name
  user_data              = local.ecs_user_data_frontend

  tags = {
    Name        = "docker-v1-frontend-server-a"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_instance" "frontend_c" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_c_front_id
  vpc_security_group_ids = [var.sg_frontend_id]
  key_name               = var.key_pair_name
  iam_instance_profile   = aws_iam_instance_profile.ecs_instance.name
  user_data              = local.ecs_user_data_frontend

  tags = {
    Name        = "docker-v1-frontend-server-c"
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
  iam_instance_profile   = aws_iam_instance_profile.ecs_instance.name
  user_data              = local.ecs_user_data_backend

  tags = {
    Name        = "docker-v1-backend-server-a"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_instance" "backend_c" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_be
  subnet_id              = var.private_subnet_c_back_id
  vpc_security_group_ids = [var.sg_backend_id]
  key_name               = var.key_pair_name
  iam_instance_profile   = aws_iam_instance_profile.ecs_instance.name
  user_data              = local.ecs_user_data_backend

  tags = {
    Name        = "docker-v1-backend-server-c"
    Project     = var.project
    Environment = var.environment
  }
}

# ─────────────────────────────────────────────────────
# OpenVPN EC2 + EIP
# ─────────────────────────────────────────────────────
resource "aws_instance" "openvpn" {
  ami                    = "ami-0c4d94bb44eff8915"
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_a_id
  vpc_security_group_ids = [var.sg_openvpn_id]
  key_name               = var.key_pair_name
  iam_instance_profile   = aws_iam_instance_profile.ecs_instance.name

  tags = {
    Name        = "docker-v1-openvpn-server"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_eip_association" "openvpn" {
  instance_id   = aws_instance.openvpn.id
  allocation_id = "eipalloc-049804da24b652d0b"
}
