output "ecs_cluster_id" {
  value       = aws_ecs_cluster.this.id
  description = "ECS 클러스터 ID"
}

output "ecs_service_name" {
  value       = aws_ecs_service.this.name
  description = "ECS 서비스 이름"
}

# output "ecs_instance_profile_name" {
#   value       = aws_iam_instance_profile.ecs_instance.name
#   description = "ECS EC2 인스턴스에서 사용할 IAM Instance Profile 이름"
# }

