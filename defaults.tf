
## Resource group variables ##
variable "environment" {
  default = "demo"
}
variable "resource_group_name" {
  default = "ace-demo"
}

## AKS kubernetes cluster variables ##
variable "k8s_version" {
  default = "1.10.7"
}

variable "cluster_name" {
  default = "ace-demo"
}

variable "agent_count" {
  default = 2
}

variable "vm_size" {
  default = "Standard_D4"
}

variable "dns_prefix" {
  default = "ace-demo"
}

variable "admin_username" {
  default = "azureuser"
}

