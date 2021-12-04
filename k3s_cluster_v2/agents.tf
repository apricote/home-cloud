resource "hcloud_server" "agents" {
  count = var.compute_count
  name  = "k3s-agent-${count.index}"

  image       = data.hcloud_image.ubuntu.name
  server_type = var.compute_server_type
  location    = var.server_location

  ssh_keys = [data.hcloud_ssh_key.default.id]
  labels = {
    provisioner = "terraform",
    engine      = "k3s",
    node_type   = "agent",
  }
}

resource "hcloud_server_network" "agents_network" {
  count     = length(hcloud_server.agents)
  server_id = hcloud_server.agents[count.index].id
  subnet_id = hcloud_network_subnet.k3s_nodes.id
  ip        = cidrhost(hcloud_network_subnet.k3s_nodes.ip_range, 1 + var.control_count + count.index)
}
