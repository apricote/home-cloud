provider "kubernetes" {
  host                   = module.k3s_cluster_v2.kubernetes.api_endpoint
  cluster_ca_certificate = module.k3s_cluster_v2.kubernetes.cluster_ca_certificate
  token                  = module.k3s_cluster_v2.kubernetes.token
}

resource "local_file" "kubeconfig-v2" {
  filename = "${path.module}/kubeconfig-v2.yaml"

  content = <<EOF
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${base64encode(module.k3s_cluster_v2.kubernetes.cluster_ca_certificate)}
    server: ${module.k3s_cluster_v2.kubernetes.api_endpoint}
  name: home-cloud-v2
contexts:
- context:
    cluster: home-cloud-v2
    user: admin
  name: home-cloud-v2
current-context: home-cloud-v2
kind: Config
preferences: {}
users:
- name: admin
  user:
    token: ${module.k3s_cluster_v2.kubernetes.token}
  EOF
}
