# Set the variable value in *.tfvars file
# or using -var="vercel_token=..." CLI option
variable "vercel_token" {}


provider "vercel" {
  api_token = var.vercel_token
}
