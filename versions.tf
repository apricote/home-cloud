terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.36.2"
    }

    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = ">= 2.2.0"
    }

    vercel = {
      source  = "vercel/vercel"
      version = ">= 0.11.4"
    }

    random = {
      source = "hashicorp/random"
    }
    template = {
      source = "hashicorp/template"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
  required_version = ">= 1.3.3"
}

