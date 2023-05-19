# kube api

data "hcloud_load_balancer" "c3_api" {
  # LB is created and managed by cluster-api-provider-hetzner
  name = "home-cloud-v3-mgtqc-kube-apiserver-4tbd8"
}

resource "hetznerdns_record" "c3_api_a" {
  zone_id = hetznerdns_zone.apricote_de.id
  name    = "c3"
  value   = data.hcloud_load_balancer.c3_api.ipv4
  type    = "A"
  ttl     = 60
}

resource "hetznerdns_record" "c3_api_aaaa" {
  zone_id = hetznerdns_zone.apricote_de.id
  name    = "c3"
  value   = data.hcloud_load_balancer.c3_api.ipv6
  type    = "AAAA"
  ttl     = 60
}

# ingress

data "hcloud_load_balancer" "c3_ingress" {
  # LB is created and managed by hccm
  name = "home-cloud-v3-traefik"
}

resource "hetznerdns_record" "c3_ingress_a" {
  zone_id = hetznerdns_zone.apricote_de.id
  name    = "*.c3-ing"
  value   = data.hcloud_load_balancer.c3_ingress.ipv4
  type    = "A"
  ttl     = 60
}

resource "hetznerdns_record" "c3_ingress_aaaa" {
  zone_id = hetznerdns_zone.apricote_de.id
  name    = "*.c3-ing"
  value   = data.hcloud_load_balancer.c3_ingress.ipv6
  type    = "AAAA"
  ttl     = 60
}
