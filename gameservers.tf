## Terraria

resource "hcloud_server" "terraria" {
  name        = "terraria"
  image       = "ubuntu-20.04"
  server_type = "cx21"
  location    = "nbg1"
  ssh_keys    = [data.hcloud_ssh_key.default.id]
}

resource "hcloud_volume" "terraria_data" {
  name     = "terraria-data"
  size     = 20
  location = "nbg1"
  format   = "ext4"
}

resource "hcloud_volume_attachment" "terraria_data" {
  volume_id = hcloud_volume.terraria_data.id
  server_id = hcloud_server.terraria.id
  automount = true
}

resource "hetznerdns_record" "terraria" {
  zone_id = hetznerdns_zone.apricote_de.id
  name    = "terraria"
  value   = hcloud_server.terraria.ipv4_address
  type    = "A"
  ttl     = 60
}
