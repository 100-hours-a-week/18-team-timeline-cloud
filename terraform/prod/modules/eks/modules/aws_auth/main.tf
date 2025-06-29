terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

data "aws_eks_cluster_auth" "this" {
    name = var.cluster_name
}

locals {
  role_mappings = concat(
    [
      for role_arn in var.node_iam_role_arns : {
        rolearn  = role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      }
    ],
    [
      for arn in var.additional_role_arns : {
        rolearn  = arn
        username = "admin:${arn}"
        groups   = ["system:masters"]
      }
    ]
  )
}

resource "kubernetes_config_map" "aws_auth" {
    metadata {
        name = "aws-auth"
        namespace = "kube-system"
    }

    data = {
        mapRoles = yamlencode(local.role_mappings)
    }

    lifecycle {
        ignore_changes = [data]
    }
}