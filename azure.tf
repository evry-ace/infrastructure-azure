variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "location" {
  default = "West Europe"
}

variable "ssh_public_key" {}

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# https://www.terraform.io/docs/backends/config.html
# https://www.terraform.io/docs/backends/types/azurerm.html
// terraform {
//   backend "azurerm" {}
// }
