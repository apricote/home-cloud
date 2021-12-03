
terraform {
  required_version = ">= 0.13"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.30"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 2.1"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 2.2"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}
