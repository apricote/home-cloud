# Set the variable value in *.tfvars file
# or using -var="hcloud_token=..." CLI option
variable "hcloud_token" {}

variable "hcloud_location" {}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  version = "~> 1.7.0"

  token = "${var.hcloud_token}"
}

#######################
## Terraform SSH Key ##
#######################

resource "hcloud_ssh_key" "terraform" {
  name       = "terraform"
  public_key = "${file("./keys/id_terraform.pub")}"
}
