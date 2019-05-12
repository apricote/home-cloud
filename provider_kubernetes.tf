provider "kubernetes" {
  version = "~> 1.6"

  host = "${rke_cluster.cluster.api_server_url}"

  client_certificate     = "${rke_cluster.cluster.client_cert}"
  client_key             = "${rke_cluster.cluster.client_key}"
  cluster_ca_certificate = "${rke_cluster.cluster.ca_crt}"
}
