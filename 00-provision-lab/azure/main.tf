# Minimal Azure lab: Linux + Windows VMs (agent-based access patterns).
# Usage: terraform init && terraform apply -var="admin_password=ComplexP@ssw0rd!"
# Connect: Azure Bastion, Run Command, or private SSH/RDP — not 0.0.0.0/0 in production.

terraform {
  required_version = ">= 1.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "lab" {
  name     = "${var.name_prefix}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "lab" {
  name                = "${var.name_prefix}-vnet"
  address_space       = ["10.40.0.0/16"]
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
}

resource "azurerm_subnet" "lab" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.40.1.0/24"]
}

resource "azurerm_network_security_group" "lab" {
  name                = "${var.name_prefix}-nsg"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
}

resource "azurerm_subnet_network_security_group_association" "lab" {
  subnet_id                 = azurerm_subnet.lab.id
  network_security_group_id = azurerm_network_security_group.lab.id
}

resource "azurerm_linux_virtual_machine" "linux" {
  name                = "${var.name_prefix}-linux"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  size                = var.linux_vm_size
  admin_username      = var.admin_username

  network_interface_ids = [azurerm_network_interface.linux.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

resource "azurerm_windows_virtual_machine" "windows" {
  name                = "${var.name_prefix}-win"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  size                = var.windows_vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [azurerm_network_interface.windows.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "linux" {
  name                = "${var.name_prefix}-linux-nic"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lab.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "windows" {
  name                = "${var.name_prefix}-win-nic"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lab.id
    private_ip_address_allocation = "Dynamic"
  }
}

output "linux_private_ip" {
  value = azurerm_linux_virtual_machine.linux.private_ip_address
}

output "windows_private_ip" {
  value = azurerm_windows_virtual_machine.windows.private_ip_address
}
