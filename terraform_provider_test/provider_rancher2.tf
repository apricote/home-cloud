variable "rancher2_api_url" {
  type = "string"
}

variable "rancher2_access_key" {
  type = "string"
}

variable "rancher2_secret_key" {
  type = "string"
}

provider "rancher2" {
  api_url    = "${var.rancher2_api_url}"
  access_key = "${var.rancher2_access_key}"
  secret_key = "${var.rancher2_secret_key}"
}
