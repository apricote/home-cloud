locals {
  cluster_name = "home-cloud"
}

module k3s_cluster {
  source = "./k3s_cluster"

  name                    = local.cluster_name
  server_image            = "ubuntu-18.04"
  server_location         = "nbg1"
  control_server_type     = "cx11"
  compute_server_type     = "cx21"
  compute_count           = 1
  domain                  = "c.apricote.de"
  letsencrypt_email       = "julian.toelle97+le@gmail.com"
  ssh_keys                = [file("./keys/id_terraform")]
  hcloud_csi_driver_token = var.hcloud_csi_driver_token
  flux_git_url            = "git@github.com:apricote/home-cloud-flux"
}
