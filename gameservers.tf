## Minecraft

resource "hcloud_server" "minecraft" {
  name        = "minecraft"
  image       = "ubuntu-20.04"
  server_type = "cx21"
  location    = "nbg1"
}

resource "hcloud_volume" "minecraft_data" {
  name = "minecraft-data"
  size = 20
}

resource "hcloud_volume_attachment" "minecraft_data" {
  volume_id = hcloud_volume.minecraft_data.id
  server_id = hcloud_server.minecraft.id
}

## Terraria

resource "hcloud_server" "terraria" {
  name        = "terraria"
  image       = "ubuntu-20.04"
  server_type = "cx21"
  location    = "nbg1"
  ssh_keys    = [data.hcloud_ssh_key.default.id]

  provisioner "file" {
    content = templatefile("./gameservers/docker-compose.terraria.yml", {
      image      = "ryshe/terraria"
      image_tag  = "tshock-1.4.3.6-4.5.17-2"
      volume_id  = hcloud_volume.terraria_data.id
      world_name = "TheDriftingMoon"
    })
    destination = "/terraria/docker-compose.yml"

    connection {
      type = "ssh"
      host = self.ipv4_address
    }
  }
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
