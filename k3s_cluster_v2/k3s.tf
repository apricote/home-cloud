module "k3s" {
  source = "xunleii/k3s/module"

  depends_on_    = hcloud_server.agents
  k3s_version    = var.install_k3s_version
  cluster_domain = "cluster.local"
  cidr = {
    pods     = "10.42.0.0/16"
    services = "10.43.0.0/16"
  }
  drain_timeout  = "30s"
  managed_fields = ["label", "taint"] // ignore annotations

  global_flags = [
    "--kubelet-arg cloud-provider=external" // required to use https://github.com/hetznercloud/hcloud-cloud-controller-manager
  ]

  servers = {
    for i in range(length(hcloud_server.control_planes)) :
    hcloud_server.control_planes[i].name => {
      ip = hcloud_server_network.control_planes[i].ip
      connection = {
        type = "ssh"
        host = hcloud_server.control_planes[i].ipv4_address

        agent = true
      }
      flags       = ["--disable-cloud-controller", "--tls-san ${var.domain}"]
      annotations = { "server_id" : i } // theses annotations will not be managed by this module
    }
  }

  agents = {
    for i in range(length(hcloud_server.agents)) :
    "${hcloud_server.agents[i].name}_node" => {
      name = hcloud_server.agents[i].name
      ip   = hcloud_server_network.agents_network[i].ip
      connection = {
        type = "ssh"
        host = hcloud_server.agents[i].ipv4_address
      }

      labels = {}
      taints = {}
    }
  }
}

provider "kubernetes" {
  host                   = module.k3s.kubernetes.api_endpoint
  cluster_ca_certificate = module.k3s.kubernetes.cluster_ca_certificate
  client_certificate     = module.k3s.kubernetes.client_certificate
  client_key             = module.k3s.kubernetes.client_key
}

resource "kubernetes_service_account" "admin" {
  depends_on = [module.k3s.kubernetes_ready]

  metadata {
    name      = "admin"
    namespace = "default"
  }
}

resource "kubernetes_cluster_role_binding" "admin" {
  depends_on = [module.k3s.kubernetes_ready]

  metadata {
    name = "admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "admin"
    namespace = "default"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
}

data "kubernetes_secret" "sa_credentials" {
  metadata {
    name      = kubernetes_service_account.admin.default_secret_name
    namespace = "default"
  }
}

## hcloud-cloud-controller-manager is necessary for cluster bootstrap

data "http" "hcloud_cloud_controller_manager" {
  url = "https://raw.githubusercontent.com/hetznercloud/hcloud-cloud-controller-manager/v1.12.1/deploy/ccm-networks.yaml"
}

locals {
  hccm_all_manifests = split("---", data.http.hcloud_cloud_controller_manager.body)

  // first element is only comment
  hccm_actual_manifests = slice(local.hccm_all_manifests, 1, length(local.hccm_all_manifests))
}

resource "kubernetes_manifest" "hcloud_cloud_controller_manager" {
  for_each = toset(
    local.hccm_actual_manifests
  )

  manifest = yamldecode(each.key)
}

resource "kubernetes_secret" "hcloud_token" {
  metadata {
    name      = "hcloud"
    namespace = "kube-system"
  }

  data = {
    token   = var.hcloud_ccm_token
    network = hcloud_network.k3s.id
  }
}
