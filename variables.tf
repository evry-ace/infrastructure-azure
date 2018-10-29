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

variable "jenkins_resource_group_name" {
    default = "ace-jenkins"
}

variable "jenkins_prefix" {
    default = "ace-jenkins"
}

variable "jenkins_vm_count" {
    default = 1
}

variable "jenkins_subnet" {
    default = "10.0.2.0/28"
}

variable "jenkins_vm_size" {
    default = "Standard_D4_v3"
}

variable "jenkins_publisher" {
    default = "bitnami"
}

variable "jenkins_offer" {
    default = "jenkins"
}

variable "jenkins_sku" {
    default = "1-650"
}

variable "jenkins_version" {
    default = "latest"
}

variable "jenkins_ssh_public_key" {
    default = "vars/keys/alpha_key.pub"
}
