resource "docker_image" "cloudflared" {
  count        = var.enable_cloudflare_tunnel ? 1 : 0
  name         = var.cloudflared_image
  keep_locally = var.keep_images_locally
}

resource "docker_container" "cloudflared" {
  count   = var.enable_cloudflare_tunnel ? 1 : 0
  name    = var.cloudflared_container_name
  image   = docker_image.cloudflared[count.index].image_id
  restart = "unless-stopped"

  command = ["tunnel", "--no-autoupdate", "run"]

  env = [
    "TUNNEL_TOKEN=${cloudflare_zero_trust_tunnel_cloudflared.n8n[0].tunnel_token}"
  ]

  networks_advanced {
    name    = docker_network.n8n.name
    aliases = ["cloudflared"]
  }

  depends_on = [
    docker_container.n8n,
    cloudflare_zero_trust_tunnel_cloudflared_config.n8n
  ]
}
