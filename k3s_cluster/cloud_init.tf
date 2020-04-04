locals {
  install_k3s_version     = var.install_k3s_version
  k3s_storage_endpoint    = "sqlite"
  k3s_cluster_secret      = var.k3s_cluster_secret != null ? var.k3s_cluster_secret : random_password.k3s_cluster_secret.result
  k3s_tls_san             = "--tls-san ${var.domain}"
  floating_ip_use_netdata = var.server_image == "ubuntu-20.04"
}

resource "random_password" "k3s_cluster_secret" {
  length  = 30
  special = false
}

data "template_cloudinit_config" "k3s_server" {
  gzip          = false
  base64_encode = false

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/files/cloud-config-base.yaml", {})
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/setup-floating-ip.sh", {
      floating_ip = hcloud_floating_ip.server.ip_address,
      use_netdata = local.floating_ip_use_netdata
    })
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/k3s-install.sh", {
      is_k3s_server       = true,
      install_k3s_version = local.install_k3s_version,
      k3s_cluster_secret  = local.k3s_cluster_secret,
      k3s_url             = hcloud_floating_ip.server.ip_address,
      k3s_tls_san         = local.k3s_tls_san,
    })
  }
}

data "template_cloudinit_config" "k3s_agent" {
  gzip          = false
  base64_encode = false

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/files/cloud-config-base.yaml", {})
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/k3s-install.sh", {
      is_k3s_server       = false,
      install_k3s_version = local.install_k3s_version,
      k3s_cluster_secret  = local.k3s_cluster_secret,
      k3s_url             = hcloud_floating_ip.server.ip_address,
      k3s_tls_san         = local.k3s_tls_san,
    })
  }
}
