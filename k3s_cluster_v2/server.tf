resource "hcloud_server" "control_planes" {
  count = var.control_count
  name  = "k3s-control-plane-${count.index}"

  image       = data.hcloud_image.ubuntu.name
  server_type = var.control_server_type
  location    = var.server_location

  ssh_keys = [data.hcloud_ssh_key.default.id]
  labels = {
    provisioner = "terraform",
    engine      = "k3s",
    node_type   = "control-plane"
  }
}

resource "hcloud_server_network" "control_planes" {
  count     = var.control_count
  subnet_id = hcloud_network_subnet.k3s_nodes.id
  server_id = hcloud_server.control_planes[count.index].id
  ip        = cidrhost(hcloud_network_subnet.k3s_nodes.ip_range, 1 + count.index)
}

# LB

resource "hcloud_load_balancer_service" "api" {
  load_balancer_id = hcloud_load_balancer.k3s.id
  protocol         = "tcp"
  listen_port      = 6443
  destination_port = 6443
}

resource "hcloud_load_balancer_target" "api" {
  count            = var.control_count
  type             = "server"
  load_balancer_id = hcloud_load_balancer.k3s.id
  server_id        = hcloud_server.control_planes[count.index].id
  use_private_ip   = true
}
