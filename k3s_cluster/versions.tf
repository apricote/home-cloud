
terraform {
  required_version = ">= 1.0"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
    }
    tls = {
      source  = "hashicorp/tls"
    }
    template = {
      source  = "hashicorp/template"
    }
    random = {
      source  = "hashicorp/random"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}
