###############################################
####               IAM Role                ####
###############################################

resource "aws_iam_role" "this" {
  name = "${var.name}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.default_tags
}

resource "aws_iam_role_policy_attachment" "node_policy_attachment" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ])
  role       = aws_iam_role.this.name
  policy_arn = each.value
}

# 커스텀 S3 접근 정책 (환경설정 파일용)
resource "aws_iam_policy" "s3_env_access" {
  name        = "${var.name}-s3-env-access"
  description = "Allow EKS nodes to access environment files from S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.project}-environment/*"  # 실제 환경설정 파일 버킷
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.project}-environment"
        ]
      }
    ]
  })

  tags = var.default_tags
}

resource "aws_iam_role_policy_attachment" "s3_env_access" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.s3_env_access.arn
}

###############################################
####              Node Group               ####
###############################################

resource "aws_eks_node_group" "this" {
    cluster_name = var.cluster_name
    node_group_name = "${var.name}-node-group"
    node_role_arn = aws_iam_role.this.arn
    subnet_ids = var.private_subnet_ids

    instance_types = var.instance_types
    disk_size = var.disk_size

    scaling_config {
        desired_size = var.desired_size
        max_size = var.max_size
        min_size = var.min_size
    }

    ami_type = var.ami_type
    capacity_type = var.capacity_type
    force_update_version = true

    tags = var.default_tags

    depends_on = [aws_iam_role_policy_attachment.node_policy_attachment]
}