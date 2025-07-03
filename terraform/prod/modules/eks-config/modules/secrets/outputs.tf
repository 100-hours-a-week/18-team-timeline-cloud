output "secret_name" {
  description = "Name of the created Kubernetes secret"
  value       = kubernetes_secret.backend_secrets.metadata[0].name
}

output "secret_namespace" {
  description = "Namespace of the created Kubernetes secret"
  value       = kubernetes_secret.backend_secrets.metadata[0].namespace
} 