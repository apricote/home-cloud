# Configure DNS with Hetzner DNS
# Domains are registered with Namecheap and NS must be entered manually for new zones.

locals {
  hetznerdns_nameservers = toset(["hydrogen.ns.hetzner.com.", "oxygen.ns.hetzner.com.", "helium.ns.hetzner.de."])
}

# apricote.de

resource "hetznerdns_zone" "apricote_de" {
  name = "apricote.de"
  ttl  = 60
}

resource "hetznerdns_record" "apricote_de_ns" {
  for_each = local.hetznerdns_nameservers

  zone_id = hetznerdns_zone.apricote_de.id
  name    = "@"
  value   = each.key
  type    = "NS"
  ttl     = 3600
}

resource "hetznerdns_record" "listory" {
  zone_id = hetznerdns_zone.apricote_de.id
  name    = "listory"
  value   = "listory.c3-ing.apricote.de."
  type    = "CNAME"
  ttl     = 60
}

resource "hetznerdns_record" "gitea" {
  zone_id = hetznerdns_zone.apricote_de.id
  name    = "gitea"
  value   = "gitea.c3-ing.apricote.de."
  type    = "CNAME"
  ttl     = 60
}

resource "hetznerdns_record" "tandoor" {
  zone_id = hetznerdns_zone.apricote_de.id
  name    = "tandoor"
  value   = "tandoor.c3-ing.apricote.de."
  type    = "CNAME"
  ttl     = 60
}


resource "hetznerdns_record" "grafana" {
  zone_id = hetznerdns_zone.apricote_de.id
  name    = "grafana"
  value   = "grafana.c3-ing.apricote.de."
  type    = "CNAME"
  ttl     = 60
}

# apricote.de proton.me

resource "hetznerdns_record" "mail_verification" {
  zone_id = hetznerdns_zone.apricote_de.id
  name    = "@"
  value   = "protonmail-verification=34adbb31866badd89ff9fc7bd0df9ceff7b4e579"
  type    = "TXT"
  ttl     = 60
}


resource "hetznerdns_record" "mail_mx_1" {
  zone_id = hetznerdns_zone.apricote_de.id
  name    = "@"
  value   = "10 mail.protonmail.ch."
  type    = "MX"
  ttl     = 60
}

resource "hetznerdns_record" "mail_mx_2" {
  zone_id = hetznerdns_zone.apricote_de.id
  name    = "@"
  value   = "20 mailsec.protonmail.ch."
  type    = "MX"
  ttl     = 60
}

resource "hetznerdns_record" "mail_spf" {
  zone_id = hetznerdns_zone.apricote_de.id
  name    = "@"
  value   = "\"v=spf1 include:_spf.protonmail.ch mx ~all\""
  type    = "TXT"
  ttl     = 60
}

resource "hetznerdns_record" "mail_dkim_1" {
  zone_id = hetznerdns_zone.apricote_de.id
  name    = "protonmail._domainkey"
  value   = "protonmail.domainkey.dg4sxfkxc2ex5uo7tsnzfkfea3s272y5c53bgbphxu6oa4qx5mzha.domains.proton.ch."
  type    = "CNAME"
  ttl     = 60
}

resource "hetznerdns_record" "mail_dkim_2" {
  zone_id = hetznerdns_zone.apricote_de.id
  name    = "protonmail2._domainkey"
  value   = "protonmail2.domainkey.dg4sxfkxc2ex5uo7tsnzfkfea3s272y5c53bgbphxu6oa4qx5mzha.domains.proton.ch."
  type    = "CNAME"
  ttl     = 60
}

resource "hetznerdns_record" "mail_dkim_3" {
  zone_id = hetznerdns_zone.apricote_de.id
  name    = "protonmail3._domainkey"
  value   = "protonmail3.domainkey.dg4sxfkxc2ex5uo7tsnzfkfea3s272y5c53bgbphxu6oa4qx5mzha.domains.proton.ch."
  type    = "CNAME"
  ttl     = 60
}

resource "hetznerdns_record" "mail_dmarc" {
  zone_id = hetznerdns_zone.apricote_de.id
  name    = "_dmarc"
  value   = "\"v=DMARC1; p=quarantine\""
  type    = "TXT"
  ttl     = 60
}

resource "hetznerdns_record" "google_site_verification_txt" {
  zone_id = hetznerdns_zone.apricote_de.id
  name    = "@"
  value   = "google-site-verification=hm7aA6DgiqqOUu_4tXnPLSqMPSptL0jgFNbXReh3VrY"
  type    = "TXT"
  ttl     = 60
}

# ein-pfeil-am-rechten-fleck.de

resource "hetznerdns_zone" "pfeil" {
  name = "ein-pfeil-am-rechten-fleck.de"
  ttl  = 60
}

resource "hetznerdns_record" "pfeil_ns" {
  for_each = local.hetznerdns_nameservers

  zone_id = hetznerdns_zone.pfeil.id
  name    = "@"
  value   = each.key
  type    = "NS"
  ttl     = 3600
}

resource "hetznerdns_record" "pfeil_a" {
  zone_id = hetznerdns_zone.pfeil.id
  name    = "@"
  value   = "76.76.21.21"
  type    = "A"
  ttl     = 60
}

resource "hetznerdns_record" "www_pfeil" {
  zone_id = hetznerdns_zone.pfeil.id
  name    = "www"
  value   = "cname.vercel-dns.com."
  type    = "CNAME"
  ttl     = 60
}
