locals {
  k3s_manifest_folder = "/var/lib/rancher/k3s/server/manifests"

  manifest_hcloud_csi_driver = templatefile("${path.module}/files/k8s-apps/hcloud-csi-driver.sh", {
    version             = var.hcloud_csi_driver_version
    token               = var.hcloud_csi_driver_token
    k3s_manifest_folder = local.k3s_manifest_folder
  })

  manifest_cert_manager_crds = templatefile("${path.module}/files/k8s-apps/cert-manager-crds.sh", {
    version             = var.cert_manager_version
    k3s_manifest_folder = local.k3s_manifest_folder
  })

  manifest_cert_manager = templatefile("${path.module}/files/k8s-apps/cert-manager.yaml", {
    version = var.cert_manager_version
    email   = var.letsencrypt_email
  })
}

resource null_resource install_manifests {
  triggers = {
    server_id = hcloud_server.server.id

    # File hashes to trigger on update
    hcloud_csi_driver = sha256(local.manifest_hcloud_csi_driver)
    cert_manager_crds = sha256(local.manifest_cert_manager_crds)
    cert_manager      = sha256(local.manifest_cert_manager)
  }

  connection {
    type        = "ssh"
    host        = hcloud_server.server.ipv4_address
    private_key = var.ssh_keys[0]
  }


  provisioner remote-exec {
    inline = [local.manifest_hcloud_csi_driver]
  }

  provisioner remote-exec {
    inline = [local.manifest_cert_manager_crds]
  }

  provisioner file {
    content     = local.manifest_cert_manager
    destination = "${local.k3s_manifest_folder}/cert-manager.yaml"
  }
}

