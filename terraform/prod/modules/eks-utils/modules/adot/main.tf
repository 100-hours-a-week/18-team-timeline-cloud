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

# ADOT Operator EKS Add-on 설치
resource "aws_eks_addon" "adot" {
  cluster_name = var.cluster_name
  addon_name   = "adot"
  addon_version = "v0.88.0-eksbuild.1"  # 최신 안정 버전

  configuration_values = jsonencode({
    adotCollector = {
      serviceAccount = {
        create = true
        annotations = {
          "eks.amazonaws.com/role-arn" = aws_iam_role.adot_collector.arn
        }
      }
    }
  })
}

# ADOT Collector용 IAM Role
resource "aws_iam_role" "adot_collector" {
  name = "${var.cluster_name}-adot-collector"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Condition = {
          StringEquals = {
            "${var.oidc_provider}:sub" = "system:serviceaccount:opentelemetry-operator-system:adot-collector"
            "${var.oidc_provider}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = var.tags
}

# CloudWatch 권한
resource "aws_iam_role_policy_attachment" "adot_amp_policy" {
  role       = aws_iam_role.adot_collector.name
  policy_arn = "arn:aws:iam::aws:policy/AWSManagedPrometheusFullAccess"
}

# X-Ray 권한
resource "aws_iam_role_policy_attachment" "adot_xray_policy" {
  role       = aws_iam_role.adot_collector.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

# ADOT Collector ConfigMap
resource "kubernetes_config_map" "adot_collector_config" {
  metadata {
    name      = "adot-collector-config"
    namespace = var.adot_namespace
  }

  data = {
    "collector-config.yaml" = templatefile("${path.module}/templates/collector-config.yaml", {
      region                    = var.region
      enable_prometheus_metrics = var.enable_prometheus_metrics
      enable_cloudwatch_metrics = var.enable_cloudwatch_metrics
      enable_xray_traces       = var.enable_xray_traces
      prometheus_scrape_interval = var.prometheus_scrape_interval
    })
  }
}

# ADOT Collector Service Account
resource "kubernetes_service_account" "adot_collector" {
  metadata {
    name      = var.adot_service_account_name
    namespace = var.adot_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.adot_collector.arn
    }
  }
}

# ADOT Collector Deployment
resource "kubernetes_deployment" "adot_collector" {
  metadata {
    name      = "adot-collector"
    namespace = var.adot_namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "adot-collector"
      }
    }

    template {
      metadata {
        labels = {
          app = "adot-collector"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.adot_collector.metadata[0].name
        
        containers {
          name  = "adot-collector"
          image = "public.ecr.aws/aws-observability/aws-otel-collector:latest"
          
          args = [
            "--config=/conf/collector-config.yaml"
          ]

          volume_mounts {
            name       = "collector-config"
            mount_path = "/conf"
          }

          resources {
            limits = {
              cpu    = "1"
              memory = "2Gi"
            }
            requests = {
              cpu    = "200m"
              memory = "400Mi"
            }
          }
        }

        volumes {
          name = "collector-config"
          config_map {
            name = kubernetes_config_map.adot_collector_config.metadata[0].name
          }
        }
      }
    }
  }
}

# ADOT Collector Service
resource "kubernetes_service" "adot_collector" {
  metadata {
    name      = "adot-collector"
    namespace = var.adot_namespace
  }

  spec {
    selector = {
      app = "adot-collector"
    }

    port {
      name        = "otlp-grpc"
      port        = 4317
      target_port = 4317
    }

    port {
      name        = "otlp-http"
      port        = 4318
      target_port = 4318
    }
  }
}

variable "cluster_name" {
  type = string
}

variable "oidc_provider" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

output "adot_collector_role_arn" {
  value = aws_iam_role.adot_collector.arn
} 