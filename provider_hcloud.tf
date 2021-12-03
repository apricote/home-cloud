# Set the variable value in *.tfvars file
# or using -var="hcloud_token=..." CLI option
variable "hcloud_token" {}

# Configure the Hetzner Cloud Provider
provider hcloud {
  version = "~> 1.30"

  token = var.hcloud_token
}
