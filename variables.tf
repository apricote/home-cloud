variable "hcloud_csi_driver_token" {
  type      = string
  sensitive = true
}

variable "hcloud_ccm_token" {
  type      = string
  sensitive = true
}

variable "github_token" {
  description = "Github Personal Access Token that is used by Terraform"
  type        = string
  sensitive   = true
}

variable "github_token_flux_notifications" {
  description = "GH PAT used by flux for notifications"
  type        = string
  sensitive   = true
}

variable "listory_token" {
  description = "Listory API Token"
  type        = string
  sensitive   = true
}
