resource "rancher2_cluster" "sandbox" {
  name        = "sandbox"
  description = "home-cloud sandbox cluster"
  kind        = "rke"

  rke_config {
    network {
      plugin = "canal"
    }

    kubernetes_version = "v1.13.4-rancher1-1"

    addons = <<ADDONS
apiVersion: v1
kind: Secret
metadata:
  name: hcloud-csi
  namespace: kube-system
stringData:
  token: ${var.hcloud_token}
---
apiVersion: v1
kind: Secret
metadata:
  name: hcloud
  namespace: kube-system
stringData:
  token: ${var.hcloud_token}
ADDONS

    addons_include = [
      "https://raw.githubusercontent.com/kubernetes/csi-api/release-1.13/pkg/crd/manifests/csidriver.yaml",
      "https://raw.githubusercontent.com/kubernetes/csi-api/release-1.13/pkg/crd/manifests/csinodeinfo.yaml",
      "https://raw.githubusercontent.com/hetznercloud/csi-driver/master/deploy/kubernetes/hcloud-csi.yml",
      "https://raw.githubusercontent.com/hetznercloud/hcloud-cloud-controller-manager/master/deploy/v1.2.0.yaml",
    ]
  }
}

resource "rancher2_node_pool" "control" {
  cluster_id       = "${rancher2_cluster.sandbox.id}"
  name             = "control"
  hostname_prefix  = "control"
  node_template_id = "user-x5qrl:nt-mdfr7"
  quantity         = 1
  control_plane    = true
  etcd             = true
  worker           = false
}

resource "rancher2_node_pool" "compute" {
  cluster_id       = "${rancher2_cluster.sandbox.id}"
  name             = "compute"
  hostname_prefix  = "compute"
  node_template_id = "user-x5qrl:nt-mdfr7"
  quantity         = 1
  control_plane    = false
  etcd             = false
  worker           = true
}
