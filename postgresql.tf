resource "docker_volume" "postgres_data" {
  name = "n8n_postgres_data"
}

resource "docker_image" "postgres" {
  name         = var.postgres_image
  keep_locally = var.keep_images_locally
}

resource "docker_container" "postgres" {
  name    = var.postgres_container_name
  image   = docker_image.postgres.image_id
  restart = "unless-stopped"

  env = [
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}",
    "POSTGRES_DB=${var.postgres_db}",
  ]

  mounts {
    target = "/var/lib/postgresql/data"
    source = docker_volume.postgres_data.name
    type   = "volume"
  }

  networks_advanced {
    name    = docker_network.n8n.name
    aliases = ["postgres"]
  }
}
