resource rancher2_node_driver hcloud {
  active            = true
  builtin           = false
  description       = "Hetzner Cloud"
  external_id       = "hcloud"
  name              = "hetzner"
  ui_url            = "https://storage.googleapis.com/hcloud-rancher-v2-ui-driver/component.js"
  url               = "https://github.com/JonasProgrammer/docker-machine-driver-hetzner/releases/download/1.2.2/docker-machine-driver-hetzner_1.2.2_linux_amd64.tar.gz"
  whitelist_domains = ["storage.googleapis.com"]
}

resource hcloud_floating_ip cluster {
  type          = "ipv4"
  home_location = "${var.hcloud_location}"
}

output cluster_ip {
  value = "${hcloud_floating_ip.cluster.ip_address}"
}
