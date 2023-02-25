locals {
  cluster_name = "home-cloud"
}

module "k3s_cluster_v2" {
  source = "./k3s_cluster_v2"

  name                = local.cluster_name
  server_image        = "ubuntu-20.04"
  server_location     = "nbg1"
  control_server_type = "cx21"
  compute_server_type = "cpx31"
  load_balancer_type  = "lb11"
  install_k3s_version = "v1.22.4+k3s1"
  control_count       = 1
  compute_count       = 1
  domain              = "c2.apricote.de"
  dns_zone_id         = hetznerdns_zone.apricote_de.id
  ssh_key             = file("~/.ssh/id_rsa.pub")
  hcloud_ccm_token    = var.hcloud_ccm_token

  ## Flux
  github_owner                    = "apricote"
  github_token                    = var.github_token
  github_token_flux_notifications = var.github_token_flux_notifications
  repository_name                 = "home-cloud-flux-v2"
  branch                          = "main"
  repository_visibility           = "private"
  target_path                     = ""
  flux_version                    = "v0.36.0"

  providers = {
    hcloud     = hcloud
    hetznerdns = hetznerdns
  }
}
