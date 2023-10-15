locals {
  postgres_dns = "pg.apricote.de"
}

resource "hcloud_volume" "postgres_data" {
  name     = "postgres-data"
  location = "fsn1"
  format   = "ext4"
  size     = 10
}

resource "hcloud_volume" "postgres_backup" {
  name     = "postgres-backup"
  location = "fsn1"
  format   = "ext4"
  size     = 10
}

module "postgres" {
  source = "../solidblocks/solidblocks-hetzner/modules/rds-postgresql"
  # version = "0.1.19"

  data_volume   = hcloud_volume.postgres_data.id
  backup_volume = hcloud_volume.postgres_backup.id

  databases         = var.postgres_databases
  db_admin_password = var.postgres_password_admin

  location = "fsn1"

  name                   = "postgres"
  postgres_major_version = "15"
  server_type            = "cax11"
  ssh_keys               = [data.hcloud_ssh_key.default.id]

  ssl_enable              = true
  ssl_domains             = [local.postgres_dns]
  ssl_email               = "certs@apricote.de"
  ssl_dns_provider        = "hetzner"
  ssl_dns_provider_config = { HETZNER_API_KEY : var.hetzner_dns_token }

  postgres_extra_config = replace(<<-EOT
# DB Version: 15
# OS Type: linux
# DB Type: mixed
# Total Memory (RAM): 4 GB
# CPUs num: 2
# Connections num: 50
# Data Storage: san

max_connections = 100
shared_buffers = 1GB
effective_cache_size = 3GB
maintenance_work_mem = 256MB
checkpoint_completion_target = 0.9
wal_buffers = 16MB
default_statistics_target = 100
random_page_cost = 1.1
effective_io_concurrency = 300
work_mem = 5242kB
huge_pages = off
min_wal_size = 1GB
max_wal_size = 4GB

# pg_stats_statements
# https://www.postgresql.org/docs/current/pgstatstatements.html
shared_preload_libraries = 'pg_stat_statements'
compute_query_id = 'on'
EOT
    , "\n", "\\n")
  # password_encryption = 'scram-sha-256'

  post_script = <<-EOT
apt-get install --no-install-recommends -qq -y postgresql-client
EOT
}

resource "hetznerdns_record" "pg_apricote_de_a" {
  zone_id = hetznerdns_zone.apricote_de.id

  name  = "pg"
  value = module.postgres.ipv4_address
  type  = "A"
  ttl   = 60
}

resource "hetznerdns_record" "pg_apricote_de_aaaa" {
  zone_id = hetznerdns_zone.apricote_de.id

  name  = "pg"
  value = module.postgres.ipv6_address
  type  = "AAAA"
  ttl   = 60
}

provider "postgresql" {
  host            = local.postgres_dns
  port            = 5432
  database        = "postgres"
  username        = "rds"
  password        = var.postgres_password_admin
  sslmode         = "verify-full"
  connect_timeout = 15
}

# Listory
resource "postgresql_role" "listory" {
  name     = "listory"
  login    = true
  password = var.postgres_password_listory
}

resource "postgresql_database" "listory" {
  name              = "listory"
  owner             = postgresql_role.listory.name
  lc_collate        = "de-DE.UTF-8"
  lc_ctype          = "de-DE.UTF-8"
  connection_limit  = -1
  allow_connections = true
}

resource "postgresql_extension" "listory_pgcrypto" {
  name     = "pgcrypto"
  database = postgresql_database.listory.name
}

resource "postgresql_extension" "listory_uuid" {
  name     = "uuid-ossp"
  database = postgresql_database.listory.name
}

# Gitea
resource "postgresql_role" "gitea" {
  name     = "gitea"
  login    = true
  password = var.postgres_password_gitea
}

resource "postgresql_database" "gitea" {
  name              = "gitea"
  owner             = postgresql_role.gitea.name
  lc_collate        = "de-DE.UTF-8"
  lc_ctype          = "de-DE.UTF-8"
  connection_limit  = -1
  allow_connections = true
}

# pghero + postgres_exporter
resource "postgresql_extension" "pg_stat_statements" {
  for_each = toset([
    postgresql_database.listory.name,
    postgresql_database.gitea.name
  ])
  name     = "pg_stat_statements"
  database = each.value
}

# postgres_exporter
resource "postgresql_role" "exporter" {
  name     = "exporter"
  login    = true
  password = var.postgres_password_exporter

  roles = ["pg_monitor"]
}
