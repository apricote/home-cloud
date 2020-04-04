output server_public_ip {
  value = hcloud_floating_ip.server.ip_address
}
