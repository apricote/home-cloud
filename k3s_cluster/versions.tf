
terraform {
  required_version = "~> 0.12.0"

  required_providers {
    hcloud   = "~> 1.2"
    tls      = "~> 2.1"
    template = "~> 2.1"
    random   = "~> 2.2"
  }
}
