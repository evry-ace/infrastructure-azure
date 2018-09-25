## Private key for the kubernetes cluster ##
resource "tls_private_key" "key" {
  algorithm   = "RSA"
}

## Azure resource group for the kubernetes cluster ##
resource "azurerm_resource_group" "k8s_cluster" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

## AKS kubernetes cluster ##
resource "azurerm_kubernetes_cluster" "k8s_cluster" {
  name                = "${var.cluster_name}"
  location            = "${azurerm_resource_group.k8s_cluster.location}"
  resource_group_name = "${azurerm_resource_group.k8s_cluster.name}"
  dns_prefix          = "${var.dns_prefix}"

  kubernetes_version  = "${var.k8s_version}"

  linux_profile {
    admin_username = "${var.admin_username}"

    ssh_key {
      key_data = "${var.ssh_public_key}"
    }
  }

  agent_pool_profile {
    name            = "default"
    count           = "${var.agent_count}"
    vm_size         = "${var.vm_size}"
    os_type         = "Linux"
    os_disk_size_gb = 50
  }

  service_principal {
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
  }

  addon_profile {
    # https://docs.microsoft.com/en-us/azure/aks/http-application-routing
    http_application_routing {
      enabled       = "${var.addon_http_routing}"
    }
  }

  tags {
    Environment = "${var.environment}"
  }
}

## Outputs ##

# Example attributes available for output
#output "id" {
#    value = "${azurerm_kubernetes_cluster.k8s_cluster.id}"
#}
#
#output "client_key" {
#  value = "${azurerm_kubernetes_cluster.k8s_cluster.kube_config.0.client_key}"
#}
#
#output "client_certificate" {
#  value = "${azurerm_kubernetes_cluster.k8s_cluster.kube_config.0.client_certificate}"
#}
#
#output "cluster_ca_certificate" {
#  value = "${azurerm_kubernetes_cluster.k8s_cluster.kube_config.0.cluster_ca_certificate}"
#}

output "kube_config" {
  value = "${azurerm_kubernetes_cluster.k8s_cluster.kube_config_raw}"
  sensitive = true
}

output "host" {
  value = "${azurerm_kubernetes_cluster.k8s_cluster.kube_config.0.host}"
}

output "configure" {
  value = <<CONFIGURE

Run the following commands to configure kubernetes client:

$ terraform output kube_config > ~/.kube/aksconfig
$ export KUBECONFIG=~/.kube/aksconfig

Test configuration using kubectl

$ kubectl get nodes
CONFIGURE
}
