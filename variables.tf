variable "environment" {}
variable "resource_group_name" {}

## AKS and ACR variables ##
variable "k8s_version" {
  default = "1.11.2"
}

variable "cluster_name" {}
variable "registry_name" {}
variable "dns_prefix" {}

variable "agent_count" {
  default = 2
}

variable "vm_size" {
  default = "Standard_D4"
}

variable "addon_http_routing" {
  default = false
}

variable "admin_username" {
  default = "azureuser"
}
