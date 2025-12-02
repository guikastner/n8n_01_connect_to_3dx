resource "docker_volume" "n8n_data" {
  name = "n8n_data"
}

resource "docker_image" "n8n" {
  name         = var.n8n_image
  keep_locally = var.keep_images_locally
}

resource "docker_container" "n8n" {
  name    = var.n8n_container_name
  image   = docker_image.n8n.image_id
  restart = "unless-stopped"

  command = var.n8n_install_3dx_nodes ? [
    "mkdir -p /home/node/.n8n/custom && cd /home/node/.n8n/custom && /usr/local/bin/npm install https://btcc.s3.dualstack.eu-west-1.amazonaws.com/widget-lab/npm/n8n-nodes-3dxinterfaces/dist/widget-lab-n8n-nodes-3dxinterfaces-0.6.0.tgz && exec n8n start"
  ] : [
    "start"
  ]

  entrypoint = var.n8n_install_3dx_nodes ? ["/bin/sh", "-c"] : null

  env = [
    "DB_TYPE=postgresdb",
    "DB_POSTGRESDB_HOST=postgres",
    "DB_POSTGRESDB_PORT=${var.postgres_port}",
    "DB_POSTGRESDB_DATABASE=${var.postgres_db}",
    "DB_POSTGRESDB_USER=${var.postgres_user}",
    "DB_POSTGRESDB_PASSWORD=${var.postgres_password}",
    "N8N_PORT=${var.n8n_port}",
    "N8N_HOST=${local.effective_n8n_host}",
  ]

  mounts {
    target = "/home/node/.n8n"
    source = docker_volume.n8n_data.name
    type   = "volume"
  }

  networks_advanced {
    name    = docker_network.n8n.name
    aliases = ["n8n"]
  }

  depends_on = [
    docker_container.postgres
  ]
}
