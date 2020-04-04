data tls_public_key default {
  count = length(var.ssh_keys)

  private_key_pem = var.ssh_keys[count.index]
}

resource hcloud_ssh_key default {
  count = length(var.ssh_keys)

  name = "${var.name}-${count.index}"

  public_key = data.tls_public_key.default[count.index].public_key_openssh
}

resource hcloud_floating_ip server {
  name          = "${var.name}-server"
  home_location = var.server_location
  description   = "Persistent IP for K3s Server. Used in Domain and for Ingress."
  type          = "ipv4"
}

resource hcloud_rdns server {
  floating_ip_id = hcloud_floating_ip.server.id
  ip_address     = hcloud_floating_ip.server.ip_address
  dns_ptr        = var.domain
}

resource hcloud_floating_ip_assignment server {
  floating_ip_id = hcloud_floating_ip.server.id
  server_id      = hcloud_server.server.id
}

resource hcloud_server server {
  name        = "${var.name}-server"
  image       = var.server_image
  server_type = var.control_server_type
  location    = var.server_location

  ssh_keys = hcloud_ssh_key.default.*.id

  connection {
    type        = "ssh"
    host        = self.ipv4_address
    private_key = var.ssh_keys[0]
  }

  user_data = data.template_cloudinit_config.k3s_server.rendered

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
    ]
  }
}


resource "random_id" "agent" {
  count = var.compute_count

  keepers = {
    image       = var.server_image
    server_type = var.control_server_type
    user_data   = sha256(data.template_cloudinit_config.k3s_agent.rendered)
  }

  byte_length = 3
}

resource hcloud_server agent {
  count = var.compute_count

  name        = "${var.name}-agent-${random_id.agent[count.index].hex}"
  image       = random_id.agent[count.index].keepers.image
  server_type = random_id.agent[count.index].keepers.server_type
  location    = var.server_location


  ssh_keys = hcloud_ssh_key.default.*.id

  connection {
    type        = "ssh"
    host        = self.ipv4_address
    private_key = var.ssh_keys[0]
  }

  user_data = data.template_cloudinit_config.k3s_agent.rendered

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
    ]
  }
}
