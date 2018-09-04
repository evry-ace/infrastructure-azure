## Resource group variables ##
variable "resource_group_name" {
  default = "ace"
}

## AKS kubernetes cluster variables ##
variable "environment" {
  default = "demo"
}

variable "k8s_version" {
  default = "1.10.7"
}

variable "cluster_name" {
  default = "ace"
}

variable "agent_count" {
  default = 2
}

variable "vm_size" {
  default = "Standard_D4"
}

variable "dns_prefix" {
  default = "ace"
}

variable "admin_username" {
  default = "azureuser"
}
