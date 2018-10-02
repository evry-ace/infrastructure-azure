resource "azurerm_storage_account" "registry" {
  name                     = "${var.registry_name}"
  resource_group_name      = "${azurerm_resource_group.k8s_cluster.name}"
  location                 = "${azurerm_resource_group.k8s_cluster.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_container_registry" "registry" {
  name                = "${var.registry_name}"
  resource_group_name = "${azurerm_resource_group.k8s_cluster.name}"
  location            = "${azurerm_resource_group.k8s_cluster.location}"
  admin_enabled       = true
  sku                 = "Classic"
  storage_account_id  = "${azurerm_storage_account.registry.id}"
}

output "registry_url" {
  value = "${azurerm_container_registry.registry.login_server}"
  sensitive = true
}

output "registry_user" {
  value = "${azurerm_container_registry.registry.admin_username}"
  sensitive = true
}

output "registry_pass" {
  value = "${azurerm_container_registry.registry.admin_password}"
  sensitive = true
}

output "registry_configure" {
  value = <<CONFIGURE

Authenticate to the Container registry by running the following command:

$ docker login \
  -u $(terraform output registry_user) \
  -p $(terraform output registry_pass) \
  $(terraform output registry_url)
CONFIGURE
}
