terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

locals {
    default_tags = merge({
        "Project" = var.name
        "ManagedBy" = "Terraform"
    },
    var.tags)
    
    # 노드 그룹들이 사용하는 모든 서브넷을 수집
    all_node_group_subnets = distinct(flatten([
        for ng in var.node_groups : ng.subnet_ids
    ]))
}

module "cluster" {
    source = "./modules/cluster"

    name =  var.name
    vpc_id = var.vpc_id
    vpc_cidr = var.vpc_cidr
    project = var.project
    environment = var.environment
    private_subnet_ids = local.all_node_group_subnets
    kubernetes_version = var.kubernetes_version

    default_tags = local.default_tags
    cluster_enabled_log_types = var.cluster_enabled_log_types
}

# 동적으로 노드 그룹 생성
module "node_groups" {
    source = "./modules/node_group"
    for_each = { for idx, ng in var.node_groups : ng.name => ng }

    name = each.value.name
    cluster_name = module.cluster.eks_cluster_name
    private_subnet_ids = each.value.subnet_ids
    default_tags = local.default_tags
    project = var.name  # 프로젝트 이름을 S3 버킷 네이밍에 사용

    instance_types = each.value.instance_types
    disk_size = each.value.disk_size
    desired_size = each.value.desired_size
    max_size = each.value.max_size
    min_size = each.value.min_size
    capacity_type = each.value.capacity_type
    ami_type = each.value.ami_type
}