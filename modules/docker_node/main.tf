resource "hcloud_server" "node" {
  name        = "${var.name}"
  image       = "${var.image}"
  server_type = "${var.server_type}"
  location    = "${var.location}"

  ssh_keys = ["${var.ssh_key_id}"]

  connection {
    private_key = "${file("./keys/id_terraform")}"
  }

  provisioner "remote-exec" {
    scripts = [
      "modules/docker_node/scripts/wait-cloud-init.sh",
      "modules/docker_node/scripts/install-docker.sh",
      "modules/docker_node/scripts/install-docker-compose.sh",
    ]
  }
}
