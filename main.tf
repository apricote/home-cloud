resource hcloud_server control {
  count       = 3
  name        = "control${count.index}"
  image       = "ubuntu-18.04"
  server_type = "cx21"

  ssh_keys = ["${hcloud_ssh_key.terraform.id}"]

  connection {
    private_key = "${file("./keys/id_terraform")}"
  }

  user_data = <<END
#cloud-config
package_upgrade: true
packages:
 - docker.io
END

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
    ]
  }

  lifecycle {
    create_before_destroy = false
  }
}

resource hcloud_server compute {
  count       = 3
  name        = "compute${count.index}"
  image       = "ubuntu-18.04"
  server_type = "cx21"

  ssh_keys = ["${hcloud_ssh_key.terraform.id}"]

  connection {
    private_key = "${file("./keys/id_terraform")}"
  }

  user_data = <<END
#cloud-config
package_upgrade: true
packages:
 - docker.io
END

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
    ]
  }

  lifecycle {
    create_before_destroy = false
  }
}

resource rke_cluster "cluster" {
  services_kube_api {
    extra_args = {
      feature-gates = "CSINodeInfo=true,CSIDriverRegistry=true"
    }
  }

  services_kubelet {
    extra_args = {
      feature-gates = "CSINodeInfo=true,CSIDriverRegistry=true"
    }
  }

  addons = <<EOL
---
apiVersion: v1
kind: Secret
metadata:
  name: hcloud-csi
  namespace: kube-system
stringData:
  token: ${var.hcloud_csi_token}
---
EOL

  addons_include = [
    "https://raw.githubusercontent.com/kubernetes/csi-api/release-1.13/pkg/crd/manifests/csidriver.yaml",
    "https://raw.githubusercontent.com/kubernetes/csi-api/release-1.13/pkg/crd/manifests/csinodeinfo.yaml",
    "https://raw.githubusercontent.com/hetznercloud/csi-driver/master/deploy/kubernetes/hcloud-csi.yml",
    "https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml",
  ]

  nodes {
    address = "${hcloud_server.control.0.ipv4_address}"
    user    = "root"
    role    = ["controlplane", "etcd"]
    ssh_key = "${file("keys/id_terraform")}"
  }

  nodes {
    address = "${hcloud_server.control.1.ipv4_address}"
    user    = "root"
    role    = ["controlplane", "etcd"]
    ssh_key = "${file("keys/id_terraform")}"
  }

  nodes {
    address = "${hcloud_server.control.2.ipv4_address}"
    user    = "root"
    role    = ["controlplane", "etcd"]
    ssh_key = "${file("keys/id_terraform")}"
  }

  nodes {
    address = "${hcloud_server.compute.0.ipv4_address}"
    user    = "root"
    role    = ["worker"]
    ssh_key = "${file("keys/id_terraform")}"
  }

  nodes {
    address = "${hcloud_server.compute.1.ipv4_address}"
    user    = "root"
    role    = ["worker"]
    ssh_key = "${file("keys/id_terraform")}"
  }

  nodes {
    address = "${hcloud_server.compute.2.ipv4_address}"
    user    = "root"
    role    = ["worker"]
    ssh_key = "${file("keys/id_terraform")}"
  }
}

resource local_file kube_cluster_yaml {
  filename = "${path.root}/kube_config_cluster.yml"
  content  = "${rke_cluster.cluster.kube_config_yaml}"
}
