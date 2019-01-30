#################
### IP ADDRESS ##
#################

resource hcloud_floating_ip main {
  type          = "${var.type}"
  description   = "${var.host}"
  home_location = "${var.location}"
}

resource "hcloud_rdns" "main" {
  floating_ip_id = "${hcloud_floating_ip.main.id}"
  ip_address     = "${hcloud_floating_ip.main.ip_address}"
  dns_ptr        = "${var.host}"
}

###################################
### ASSIGNMENT AND PROVISIONING ###
###################################

data "template_file" "network_config" {
  template = "${file("modules/floating_ip/files/99-floating.cfg")}"

  vars {
    FLOATING_IP = "${hcloud_floating_ip.main.ip_address}"
  }
}

resource hcloud_floating_ip_assignment main {
  floating_ip_id = "${hcloud_floating_ip.main.id}"
  server_id      = "${var.server_id}"

  connection = {
    host        = "${var.server_ip}"
    private_key = "${file("keys/id_terraform")}"
  }

  provisioner file {
    content     = "${data.template_file.network_config.rendered}"
    destination = "/etc/network/interfaces.d/99-floating.cfg"
  }

  provisioner remote-exec {
    inline = [
      "ifdown eth0:1 ; ifup eth0:1",
    ]
  }
}
