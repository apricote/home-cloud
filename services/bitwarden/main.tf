##########
## NODE ##
##########
module "node" {
  source = "../../modules/docker_node"

  name = "${var.name}"

  ssh_key_id = "${var.ssh_key_id}"
}

############
## VOLUME ##
############

resource "hcloud_volume" "data" {
  name     = "${var.volume_name}"
  size     = "${var.volume_size}"
  location = "${var.location}"

  format = "ext4"
}

resource hcloud_volume_attachment "data" {
  volume_id = "${hcloud_volume.data.id}"
  server_id = "${module.node.id}"

  automount = true
}

resource null_resource "start-stop-bitwarden" {
  # This resource is responsible for starting and stopping Bitwarden before
  # changing volume assignments. This should avoid data corruption.
  depends_on = ["hcloud_volume_attachment.data", "null_resource.install-bitwarden"]

  triggers = {
    id = "${hcloud_volume_attachment.data.id}"
  }

  connection = {
    host        = "${module.node.ip}"
    private_key = "${file("keys/id_terraform")}"
  }

  provisioner remote-exec {
    # Stop bitwarden container before unmounting data volume
    when = "destroy"

    inline = [
      "echo Stopping Bitwarden",
      "docker stop bitwarden",
    ]
  }

  provisioner remote-exec {
    # Start bitwarden after mounting new volume
    inline = [
      "echo Starting Bitwarden",
      "cd ${local.install_dir}",
      "docker-compose up -d",
    ]
  }
}

################
## IP ADDRESS ##
################

module floating_ip {
  source = "../../modules/floating_ip"

  location  = "${var.location}"
  host      = "${var.host}"
  server_id = "${module.node.id}"
  server_ip = "${module.node.ip}"
}

#################
## APPLICATION ##
#################

data "template_file" "compose" {
  template = "${file("services/bitwarden/files/docker-compose.yaml")}"

  vars = {
    INSTALL_DIR           = "${local.install_dir}"
    BITWARDEN_DATA_DIR    = "${local.bitwarden_data_dir}"
    BITWARDEN_ADMIN_EMAIL = "${var.bitwarden_admin_email}"
    HOST                  = "${var.host}"
  }
}

resource "null_resource" "install-bitwarden" {
  depends_on = ["module.node", "hcloud_volume_attachment.data"]

  triggers {
    node_id   = "${module.node.id}"
    volume_id = "${hcloud_volume.data.id}"

    docker_compose = "${sha1(data.template_file.compose.rendered)}"
    traefik_config = "${sha1(file("services/bitwarden/files/traefik.toml"))}"
  }

  connection = {
    host        = "${module.node.ip}"
    private_key = "${file("keys/id_terraform")}"
  }

  provisioner remote-exec {
    inline = [
      "mkdir -p ${local.install_dir}",
      "touch ${local.install_dir}/acme.json",
      "chmod 600 ${local.install_dir}/acme.json",
    ]
  }

  provisioner file {
    content     = "${data.template_file.compose.rendered}"
    destination = "${local.install_dir}/docker-compose.yaml"
  }

  provisioner file {
    source      = "services/bitwarden/files/traefik.toml"
    destination = "${local.install_dir}/traefik.toml"
  }

  provisioner remote-exec {
    inline = [
      "cd ${local.install_dir}",
      "docker-compose pull",
      "docker-compose up -d",
    ]
  }
}
