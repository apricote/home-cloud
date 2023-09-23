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