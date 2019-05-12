resource hcloud_server control {
  count       = 3
  name        = "control${count.index}"
  image       = "ubuntu-18.04"
  server_type = "cx21"
}

resource hcloud_server compute {
  count       = 3
  name        = "compute${count.index}"
  image       = "ubuntu-18.04"
  server_type = "cx21"
}

data "template_file" "ansible_inventory" {
  template = "${file("${path.module}/templates/ansible_inventory.cfg")}"

  depends_on = [
    "hcloud_server.control",
    "hcloud_server.compute",
  ]

  vars {
    control = "${join("\n", hcloud_server.control.*.ipv4_address)}"
    compute = "${join("\n", hcloud_server.compute.*.ipv4_address)}"
  }
}

resource "null_resource" "ansible_inventory" {
  triggers {
    template_rendered = "${data.template_file.ansible_inventory.rendered}"
  }

  provisioner "local-exec" {
    command = "echo '${data.template_file.ansible_inventory.rendered}' > ansible_inventory"
  }
}
