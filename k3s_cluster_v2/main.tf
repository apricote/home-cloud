data "hcloud_ssh_key" "default" {
  name = "default"
}

resource "hcloud_network" "k3s" {
  name     = "k3s-network"
  ip_range = "10.0.0.0/8"
}

resource "hcloud_network_subnet" "k3s_nodes" {
  type         = "cloud"
  network_id   = hcloud_network.k3s.id
  network_zone = "eu-central"
  ip_range     = "10.254.1.0/24"
}

resource "hcloud_network_subnet" "lb" {
  type         = "cloud"
  network_id   = hcloud_network.k3s.id
  network_zone = "eu-central"
  ip_range     = "10.254.2.0/24"
}

data "hcloud_image" "ubuntu" {
  name = var.server_image
}

### Loadbalancer

resource "hcloud_load_balancer" "k3s" {
  name               = "k3s"
  load_balancer_type = var.load_balancer_type
  location           = var.server_location
}

resource "hcloud_load_balancer_network" "k3s" {
  load_balancer_id = hcloud_load_balancer.k3s.id
  subnet_id        = hcloud_network_subnet.lb.id
}


resource "hcloud_rdns" "k3s_ipv4" {
  load_balancer_id = hcloud_load_balancer.k3s.id
  ip_address       = hcloud_load_balancer.k3s.ipv4
  dns_ptr          = var.domain
}

resource "hcloud_rdns" "k3s_ipv6" {
  load_balancer_id = hcloud_load_balancer.k3s.id
  ip_address       = hcloud_load_balancer.k3s.ipv6
  dns_ptr          = var.domain
}

### LB Ingress

resource "hcloud_load_balancer_service" "ingress_https" {
  load_balancer_id = hcloud_load_balancer.k3s.id
  protocol         = "tcp"
  listen_port      = 443
  destination_port = 32443
}

resource "hcloud_load_balancer_service" "ingress_http" {
  load_balancer_id = hcloud_load_balancer.k3s.id
  protocol         = "tcp"
  listen_port      = 80
  destination_port = 32080
}

### Domain

resource "hetznerdns_record" "ipv4" {
  zone_id = var.dns_zone_id
  name    = var.domain
  value   = hcloud_load_balancer.k3s.ipv4
  type    = "A"
  ttl     = 60
}

resource "hetznerdns_record" "ipv6" {
  zone_id = var.dns_zone_id
  name    = var.domain
  value   = hcloud_load_balancer.k3s.ipv6
  type    = "AAAA"
  ttl     = 60
}

resource "hetznerdns_record" "wildcard" {
  # *.domain CNAME domain
  zone_id = var.dns_zone_id
  name    = "*"
  value   = var.domain
  type    = "CNAME"
  ttl     = 60
}
