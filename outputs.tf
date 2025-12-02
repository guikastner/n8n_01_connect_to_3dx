output "n8n_service" {
  description = "Resumo do serviço n8n exposto via Docker e túnel."
  value = {
    public_hostname = local.effective_n8n_host
    listen_port     = var.n8n_port
    container_name  = docker_container.n8n.name
    image           = docker_image.n8n.name
    network         = docker_network.n8n.name
  }
}

output "postgres_service" {
  description = "Resumo do banco Postgres usado pelo n8n."
  value = {
    container_name = docker_container.postgres.name
    image          = docker_image.postgres.name
    port           = var.postgres_port
    network        = docker_network.n8n.name
    db_name        = var.postgres_db
    db_user        = var.postgres_user
  }
}

output "cloudflared_connector" {
  description = "Container e túnel utilizados para expor o n8n via Cloudflare."
  value = {
    container_name = docker_container.cloudflared.name
    image          = docker_image.cloudflared.name
    tunnel_name    = local.tunnel_name_resolved
    tunnel_id      = cloudflare_zero_trust_tunnel_cloudflared.n8n.id
    dns_cname      = local.n8n_cname_resolved
    cname_target   = cloudflare_zero_trust_tunnel_cloudflared.n8n.cname
  }
}

output "cloudflare_dns" {
  description = "Registros DNS provisionados no Cloudflare para o n8n."
  value = {
    zone_id = var.cloudflare_zone_id
    name    = cloudflare_record.n8n_cname.name
    type    = cloudflare_record.n8n_cname.type
    proxied = cloudflare_record.n8n_cname.proxied
  }
}

output "docker_network" {
  description = "Rede Docker compartilhada entre n8n, Postgres e cloudflared."
  value = docker_network.n8n.name
}
