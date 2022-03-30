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
