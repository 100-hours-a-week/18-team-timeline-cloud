terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

# aws-auth ConfigMap 관리
resource "kubernetes_config_map_v1_data" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode(concat(
      # 노드 그룹 역할들
      [
        for role_arn in var.node_iam_role_arns : {
          rolearn  = role_arn
          username = "system:node:{{EC2PrivateDNSName}}"
          groups   = ["system:bootstrappers", "system:nodes"]
        }
      ],
      # 추가 역할들 (bastion 등)
      [
        for role_arn in var.additional_role_arns : {
          rolearn  = role_arn
          username = "admin"
          groups   = ["system:masters"]
        }
      ]
    ))
  }

  force = true
}
