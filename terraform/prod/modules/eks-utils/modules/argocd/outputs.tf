# output "argocd_server_url" {
#   description = "ArgoCD Server URL"
#   value       = data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].hostname != "" ? "https://${data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].hostname}" : "LoadBalancer not ready"
# }

# output "argocd_initial_admin_password" {
#   description = "Initial admin password"
#   value       = try(data.kubernetes_secret.argocd_initial_admin_secret.data["password"], "password-not-ready")
#   sensitive   = true
# }

# output "argocd_namespace" {
#   description = "The namespace where ArgoCD is installed"
#   value       = kubernetes_namespace.argocd.metadata[0].name
# }

output "argocd_admin_username" {
  description = "ArgoCD admin username"
  value       = "admin"
} 