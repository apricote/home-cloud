resource "hcloud_volume" "postgres_data" {
  name      = "postgres-data"
  location  = "fsn1"
  format    = "ext4"
  automount = true
  size      = 10
}

resource "hcloud_volume" "postgres_backup" {
  name      = "postgres-backup"
  location  = "fsn1"
  format    = "ext4"
  automount = true
  size      = 10
}

module "postgres" {
  source  = "pellepelster/solidblocks-rds-postgresql/hcloud"
  version = "0.1.19"

  data_volume   = hcloud_volume.postgres_data.id
  backup_volume = hcloud_volume.postgres_backup.id

  databases = var.postgres_databases

  location = "fsn1"

  name                   = "postgres"
  postgres_major_version = "15"
  server_type            = "cax11"
  ssh_keys               = [data.hcloud_ssh_key.default.id]

  ssl_enable              = true
  ssl_domains             = ["pg.apricote.de"]
  ssl_email               = "certs@apricote.de"
  ssl_dns_provider        = "hetzner"
  ssl_dns_provider_config = { HETZNER_API_KEY : var.hetzner_dns_token }
}

resource "hetznerdns_record" "pg_apricote_de_a" {
  zone_id = hetznerdns_zone.apricote_de.id

  name  = "pg"
  value = module.postgres.ipv4_address
  type  = "A"
  ttl   = 60
}
