module bitwarden {
  source = "services/bitwarden"

  location              = "${var.hcloud_location}"
  ssh_key_id            = "${hcloud_ssh_key.terraform.id}"
  bitwarden_admin_email = "${var.admin_email}"
}

variable admin_email {
  type = "string"
}
