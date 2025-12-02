# Configurações relacionadas ao Cloudflare
# Mantém o host efetivo usado pelo n8n a partir do domínio configurado.
locals {
  n8n_cname_resolved        = var.n8n_cname != null ? "${var.n8n_cname}.${var.cloudflare_domain}" : var.cloudflare_domain
  effective_n8n_host        = coalesce(var.n8n_host, local.n8n_cname_resolved, "localhost")
  tunnel_name_resolved      = coalesce(var.cloudflare_managed_tunnel_name, "n8n-tunnel")
  ingress_catch_all_service = coalesce(var.cloudflare_catch_all_ingress_service, "http://n8n:5678")
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "random_password" "cloudflare_tunnel_secret" {
  count = var.enable_cloudflare_tunnel ? 1 : 0
  length           = 64
  special          = false
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "n8n" {
  count      = var.enable_cloudflare_tunnel ? 1 : 0
  account_id = var.cloudflare_account_id
  name       = local.tunnel_name_resolved
  secret     = base64encode(random_password.cloudflare_tunnel_secret[0].result)
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "n8n" {
  count = var.enable_cloudflare_tunnel ? 1 : 0
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.n8n[0].id

  config {
    ingress_rule {
      hostname = local.n8n_cname_resolved
      service  = local.ingress_catch_all_service
    }

    ingress_rule {
      service = "http_status:404"
    }
  }
}

resource "cloudflare_record" "n8n_cname" {
  count   = var.enable_cloudflare_tunnel ? 1 : 0
  zone_id = var.cloudflare_zone_id
  name    = local.n8n_cname_resolved
  type    = "CNAME"
  content = cloudflare_zero_trust_tunnel_cloudflared.n8n[0].cname
  proxied = true

  depends_on = [cloudflare_zero_trust_tunnel_cloudflared_config.n8n]
}
