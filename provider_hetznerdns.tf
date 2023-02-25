# Set the variable value in *.tfvars file
# or using -var="hetzner_dns_token=..." CLI option
variable "hetzner_dns_token" {}

# Configure the Hetzner DNS Provider
provider "hetznerdns" {
  apitoken = var.hetzner_dns_token
}
