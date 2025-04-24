output "namespace" {
  description = "Namespace where Argo CD is deployed"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "release_name" {
  description = "Name of the Argo CD Helm release"
  value       = helm_release.argocd.name
}

output "release_status" {
  description = "Status of the release"
  value       = helm_release.argocd.status
}

output "server_service_name" {
  description = "Name of the Argo CD server service"
  value       = "${var.helm_release_name}-argocd-server"
}