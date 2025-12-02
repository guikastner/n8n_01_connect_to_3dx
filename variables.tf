variable "cloudflare_api_token" {
  description = "Token de API do Cloudflare (opcional, reservado para automações futuras)."
  type        = string
  sensitive   = true
  default     = null
}

variable "cloudflare_account_id" {
  description = "Account ID do Cloudflare (opcional)."
  type        = string
  default     = null
}

variable "cloudflare_zone_id" {
  description = "Zone ID do Cloudflare (opcional)."
  type        = string
  default     = null
}

variable "cloudflare_domain" {
  description = "Domínio que será publicado via túnel (ex.: app.example.com)."
  type        = string
  default     = "app.example.com"
}

variable "n8n_cname" {
  description = "Prefixo do CNAME do n8n na Cloudflare (ex.: n8n, app)."
  type        = string
  default     = null
}

variable "cloudflare_managed_tunnel_name" {
  description = "Nome amigável do túnel (opcional, para referência)."
  type        = string
  default     = null
}

variable "cloudflare_catch_all_ingress_service" {
  description = "Serviço padrão para o catch-all do ingress do cloudflared (opcional)."
  type        = string
  default     = null
}

variable "postgres_user" {
  description = "Usuário do banco Postgres usado pelo n8n."
  type        = string
  default     = "n8n"
}

variable "postgres_password" {
  description = "Senha do banco Postgres (defina em .env)."
  type        = string
  sensitive   = true
}

variable "postgres_db" {
  description = "Nome do banco Postgres."
  type        = string
  default     = "n8n"
}

variable "postgres_port" {
  description = "Porta do Postgres exposta no host."
  type        = number
  default     = 5432
}

variable "n8n_port" {
  description = "Porta do n8n exposta no host."
  type        = number
  default     = 5678
}

variable "n8n_host" {
  description = "Host usado pelo n8n para construir URLs públicas."
  type        = string
  default     = null
}

variable "n8n_container_name" {
  description = "Nome do container do n8n."
  type        = string
  default     = "n8n"
}

variable "n8n_image" {
  description = "Imagem Docker do n8n."
  type        = string
  default     = "n8nio/n8n:1.66.1"
}

variable "postgres_container_name" {
  description = "Nome do container do Postgres."
  type        = string
  default     = "n8n-postgres"
}

variable "postgres_image" {
  description = "Imagem Docker do Postgres."
  type        = string
  default     = "postgres:15-alpine"
}

variable "cloudflared_container_name" {
  description = "Nome do container do cloudflared."
  type        = string
  default     = "n8n-cloudflared"
}

variable "cloudflared_image" {
  description = "Imagem Docker do cloudflared."
  type        = string
  default     = "cloudflare/cloudflared:latest"
}
