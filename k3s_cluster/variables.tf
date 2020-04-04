variable name {
  type = string
}

variable server_image {
  type = string
  # With ubuntu-20.04 k3s crashes on start (v1.17.4+k3s1)
  default = "ubuntu-18.04"
}

variable server_location {
  type = string
}

variable control_server_type {
  type    = string
  default = "cx11"
}

variable compute_server_type {
  type    = string
  default = "cx21"
}

variable compute_count {
  type    = number
  default = 1
}

variable domain {
  type = string
}

variable letsencrypt_email {
  type        = string
  default     = "none@none.com"
  description = "LetsEncrypt email address to use"
}

variable ssh_keys {
  type    = list(string)
  default = []
}

variable install_k3s_version {
  type    = string
  default = "1.17.4+k3s1"
}

variable k3s_cluster_secret {
  type    = string
  default = null
}

variable hcloud_csi_driver_version {
  type    = string
  default = "v1.2.3"
}

variable hcloud_csi_driver_token {
  type = string
}

variable cert_manager_version {
  type    = string
  default = "v0.14.3"
}
