output "summary" {
  value = module.k3s.summary
}

output "kubernetes" {
  description = "Authentication credentials of Kubernetes (full administrator)."
  value = {
    token                  = data.kubernetes_secret.sa_credentials.data.token
    cluster_ca_certificate = module.k3s.kubernetes.cluster_ca_certificate
    api_endpoint           = "https://${var.domain}:6443"
  }
  sensitive = true
}

output "kubernetes_ready" {
  description = "Dependency endpoint to synchronize k3s installation and provisioning."
  value       = module.k3s.kubernetes_ready
}
