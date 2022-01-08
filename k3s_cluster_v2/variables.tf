variable "name" {
  type = string
}

variable "server_image" {
  type = string
  # With ubuntu-20.04 k3s crashes on start (v1.17.4+k3s1)
  default = "ubuntu-18.04"
}

variable "server_location" {
  type = string
}

variable "control_server_type" {
  type    = string
  default = "cx21"
}

variable "compute_server_type" {
  type    = string
  default = "cpx21"
}

variable "control_count" {
  description = "Number of control plane nodes."
  default     = 3
}

variable "compute_count" {
  type    = number
  default = 1
}

variable "load_balancer_type" {
  type    = string
  default = "lb11"
}

variable "domain" {
  type = string
}

variable "install_k3s_version" {
  type    = string
  default = "v1.22.4+k3s1"
}

variable "ssh_key" {
  description = "SSH public Key content needed to provision the instances."
  type        = string
}

variable "hcloud_ccm_token" {
  description = "HCloud API Token used by the hcloud-cloud-controller-manager"
  type        = string
  sensitive   = true
}

## Flux
variable "github_owner" {
  type = string
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "github_token_flux_notifications" {
  type      = string
  sensitive = true
}

variable "repository_name" {
  type = string
}

variable "branch" {
  type = string
}

variable "repository_visibility" {
  type = string
}

variable "flux_version" {
  type = string
}

variable "target_path" {
  type        = string
  description = "Relative path to the Git repository root where Flux manifests are committed."
}
