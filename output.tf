output "cluster_public_ip" {
  value = module.k3s_cluster.server_public_ip
}

output "cluster_name" {
  value = local.cluster_name
}

output "summary" {
  value = module.k3s_cluster_v2.summary
}
