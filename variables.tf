variable "listory_token" {
  description = "Listory API Token"
  type        = string
  sensitive   = true
}

variable "postgres_databases" {
  description = "Postgres databases to create"
  type        = list(object({
    id       = string
    user     = string
    password = string
  }))
  sensitive = true
}

variable "postgres_password_admin" {
  description = "Postgres admin password"
  type        = string
  sensitive   = true
}

variable "postgres_password_listory" {
  description = "Postgres listory password"
  type        = string
  sensitive   = true
}

variable "postgres_password_gitea" {
  description = "Postgres gitea password"
  type        = string
  sensitive   = true
}

variable "postgres_password_exporter" {
  description = "Postgres exporter password"
  type        = string
  sensitive   = true
}
