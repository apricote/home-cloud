variable location {
  type    = "string"
  default = "nbg1"
}

variable ssh_key_id {
  type = "string"
}

variable volume_size {
  type    = "string"
  default = 10
}

variable name {
  type    = "string"
  default = "bitwarden"
}

variable volume_name {
  type    = "string"
  default = "bitwarden-data"
}

variable host {
  type    = "string"
  default = "bitwarden.apricote.de"
}

variable bitwarden_admin_email {
  type = "string"
}

locals = {
  volume_path = "/mnt/${var.volume_name}"

  install_dir        = "/opt/${var.name}"
  bitwarden_data_dir = "${local.volume_path}"
}
