output ip {
  value = "${hcloud_server.node.ipv4_address}"
}

output id {
  value = "${hcloud_server.node.id}"
}
