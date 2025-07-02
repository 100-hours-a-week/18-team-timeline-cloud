terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

# Parameter Store에서 Redis password 읽어오기
data "aws_ssm_parameter" "redis_password" {
  name = "/tamnara/prod/redis/password"
}

# Kubernetes Secret 생성
resource "kubernetes_secret" "backend_secrets" {
  metadata {
    name      = "backend-secrets"
    namespace = var.namespace
  }

  data = {
    REDIS_PASSWORD = data.aws_ssm_parameter.redis_password.value
  }

  type = "Opaque"
} 