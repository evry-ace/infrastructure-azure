

resource "azurerm_resource_group" "ace-jenkins-rg" {
  name     = "${var.jenkins_resource_group_name}"
  location = "${var.location}"
}

# resource "azurerm_storage_account" "ace-jenkins-sa" {
#   name                     = "${var.prefix}-sa"
#   resource_group_name      = "${azurerm_subnet.ace-jenkins-rg.name}"
#   location                 = "${var.location}"
#   account_tier             = "Standard"
#   account_replication_type = "GRS"

#   tags {
#     environment = "test"
#   }
# }

# resource "azurerm_managed_disk" "ace-jenkins-disk" {
#   name = "${var.prefix}-disk"
#   location = "${var.location}"
#   resource_group_name = "${azurerm_resource_group.ace-jenkins-rg.name}"
#   storage_account_type = "Premium_LRS"
#   create_option = "Empty"
#   disk_size_gb = "400"

#   tags {
#     environment = "staging"
#   }
# }

resource "azurerm_storage_account" "ace-jenkins-diagnostic-sa" {
  name                     = "${replace(var.jenkins_prefix, "-", "")}diagnosticsa"
  resource_group_name      = "${azurerm_resource_group.ace-jenkins-rg.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags {
    environment = "${var.environment}"
  }
}

resource "azurerm_public_ip" "ace-jenkins-public-ip" {
  name                         = "ace-jenkins-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.ace-jenkins-rg.name}"
  public_ip_address_allocation = "static"

  tags {
    environment = "${var.environment}"
  }
}

resource "azurerm_virtual_network" "ace-jenkins-network" {
  name                = "${var.jenkins_prefix}-network"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.ace-jenkins-rg.name}"
  address_space       = ["${var.jenkins_subnet}"]
  dns_servers         = ["8.8.8.8", "1.1.1.1"]

  tags {
    environment = "${var.environment}"
  }
}

resource "azurerm_network_security_group" "ace-jenkins-sg" {
  name                = "${var.jenkins_prefix}-sh"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.ace-jenkins-rg.name}"
  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "${var.environment}"
  }
}

resource "azurerm_subnet" "ace-jenkins-subnet" {
  name                 = "${var.jenkins_prefix}-subnet"
  resource_group_name  = "${azurerm_resource_group.ace-jenkins-rg.name}"
  virtual_network_name = "${azurerm_virtual_network.ace-jenkins-network.name}"
  address_prefix       = "${var.jenkins_subnet}"
}

resource "azurerm_network_interface" "ace-jenkins-nic" {
  name                  = "${var.jenkins_prefix}-nic"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.ace-jenkins-rg.name}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.ace-jenkins-subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.ace-jenkins-public-ip.id}"
  }

  tags {
    environment = "${var.environment}"
  }
}

resource "azurerm_virtual_machine" "ace-jenkins-vm" {
    count                             = "${var.jenkins_vm_count}"
    name                              = "${var.jenkins_prefix}-${count.index}"
    location                          = "${var.location}"
    resource_group_name               = "${azurerm_resource_group.ace-jenkins-rg.name}"
    network_interface_ids             = ["${element(azurerm_network_interface.ace-jenkins-nic.*.id, count.index)}"]
    vm_size                           = "${var.jenkins_vm_size}"
    delete_data_disks_on_termination  = true
    delete_os_disk_on_termination     = true

    plan {
        publisher = "${var.jenkins_publisher}"
        product = "${var.jenkins_offer}"
        name = "${var.jenkins_sku}"
    }

    boot_diagnostics {
        enabled = true
        storage_uri = "${azurerm_storage_account.ace-jenkins-diagnostic-sa.primary_blob_endpoint}"
    }

    storage_image_reference {
        publisher = "${var.jenkins_publisher}"
        offer = "${var.jenkins_offer}"
        sku = "${var.jenkins_sku}"
        version = "${var.jenkins_version}"
    }

    storage_os_disk {
        name = "osdisk"
        managed_disk_type = "Premium_LRS"
        caching = "ReadWrite"
        create_option = "FromImage"
    }


    # storage_data_disk {
    #     name            = "${data.azurerm_managed_disk.ace-jenkins-disk.name}"
    #     managed_disk_id = "${data.azurerm_managed_disk.ace-jenkins-disk.id}"
    #     create_option   = "Attach"
    #     lun             = 0
    #     disk_size_gb    = "${data.azurerm_managed_disk.ace-jenkins-disk.disk_size_gb}"
    # }

    os_profile {
        computer_name  = "${var.jenkins_prefix}-${count.index}"
        admin_username = "${var.admin_username}"
    }
    
    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys = [{
            path     = "/home/${var.admin_username}/.ssh/authorized_keys"
            key_data = "${replace(file("${var.jenkins_ssh_public_key}"),"\n","")}"
        }]
    }

    tags {
      environment = "${var.environment}"
    }
}