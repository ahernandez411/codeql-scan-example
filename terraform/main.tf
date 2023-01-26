# Example code taken from:
# https://aquasecurity.github.io/tfsec/v0.61.3/checks/azure/compute/disable-password-authentication/

resource "azurerm_resource_group" "example" {
  name     = "my-rgrp"
  location = "West US2"
}

resource "azurerm_storage_account" "bad_example" {
  name                      = "badnamesa"
  resource_group_name       = azurerm_resource_group.example.name
  location                  = azurerm_resource_group.example.location
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  enable_https_traffic_only = false
}

resource "azurerm_linux_virtual_machine" "bad_linux_example" {
  name                            = "bad-linux-machine"
  resource_group_name             = azurerm_resource_group.example.name
  location                        = azurerm_resource_group.example.location
  size                            = "Standard_F2"
  admin_username                  = "adminuser"
  admin_password                  = "somePassword"
  disable_password_authentication = false
}

resource "azurerm_virtual_machine" "bad_example" {
  name                = "bad-linux-machine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "somePassword"

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_kubernetes_cluster" "bad_example" {
  addon_profile {}
}

resource "azurerm_key_vault" "bad_example" {
  name                        = "bad_examplekeyvault"
  location                    = azurerm_resource_group.example.location
  enabled_for_disk_encryption = true
  purge_protection_enabled    = false
}

resource "azurerm_monitor_log_profile" "bad_example" {
  name = "bad_example"

  retention_policy {
    enabled = true
    days    = 7
  }
}

resource "azurerm_network_security_rule" "bad_example" {
  name                       = "bad_example_security_rule"
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "TCP"
  source_port_range          = "*"
  destination_port_range     = ["3389"]
  source_address_prefix      = "*"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_group" "example" {
  name                = "tf-appsecuritygroup"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    source_port_range          = "any"
    destination_port_range     = ["3389"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
