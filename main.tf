terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.46.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.6.0"
    }
  }
  
  # Backend para armazenar estado no Azure Storage
  # RG: rg-blob-br-tsstate-tf-prod (apenas para estado do TF)
  backend "azurerm" {
    resource_group_name  = "rg-blob-br-tsstate-tf-prod"
    storage_account_name = "stterraformstate7479"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Random suffix para recursos únicos
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Resource Group para deploy (VM, SQL, etc)
resource "azurerm_resource_group" "dev" {
  name     = "rg-dev-sql-vm"
  location = "East US"
}

# Data source para Key Vault existente
data "azurerm_key_vault" "terraform_kv" {
  name                = "kv-dev-terraform-667"
  resource_group_name = "rg-blob-br-tsstate-tf-prod"
}

# Data sources para secrets do Key Vault
data "azurerm_key_vault_secret" "vm_admin_password" {
  name         = "vm-admin-password"
  key_vault_id = data.azurerm_key_vault.terraform_kv.id
}

# Virtual Network
resource "azurerm_virtual_network" "dev" {
  name                = "vnet-dev"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.dev.location
  resource_group_name = azurerm_resource_group.dev.name
}

# Subnet
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.dev.name
  virtual_network_name = azurerm_virtual_network.dev.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Public IP
resource "azurerm_public_ip" "dev" {
  name                = "vm-dev-pip"
  resource_group_name = azurerm_resource_group.dev.name
  location            = azurerm_resource_group.dev.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Security Group
resource "azurerm_network_security_group" "dev" {
  name                = "vm-dev-nsg"
  location            = azurerm_resource_group.dev.location
  resource_group_name = azurerm_resource_group.dev.name

  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "177.214.188.64/32"
    destination_address_prefix = "*"
  }
}

# Network Interface
resource "azurerm_network_interface" "dev" {
  name                = "vm-dev-nic"
  location            = azurerm_resource_group.dev.location
  resource_group_name = azurerm_resource_group.dev.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dev.id
  }
}

# Associate Network Security Group to Network Interface
resource "azurerm_network_interface_security_group_association" "dev" {
  network_interface_id      = azurerm_network_interface.dev.id
  network_security_group_id = azurerm_network_security_group.dev.id
}

# Virtual Machine
resource "azurerm_windows_virtual_machine" "dev" {
  name                = "vm-dev"
  resource_group_name = azurerm_resource_group.dev.name
  location            = azurerm_resource_group.dev.location
  size                = "Standard_B1s"  # Menor custo possível
  admin_username      = "devadmin"
  admin_password      = data.azurerm_key_vault_secret.vm_admin_password.value

  network_interface_ids = [
    azurerm_network_interface.dev.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"  # Menor custo
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}