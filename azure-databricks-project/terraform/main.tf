# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~>1.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-blob-br-tsstate-tf-prod"
    storage_account_name = "stterraformstate7479"
    container_name       = "tfstate"
    key                  = "databricks.terraform.tfstate"
  }
}

# Configure the Azure Provider
provider "azurerm" {
  features {}
}

# Data source for existing Key Vault
data "azurerm_key_vault" "existing" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group
}

# Data source for VM admin password from Key Vault
data "azurerm_key_vault_secret" "vm_admin_password" {
  name         = "vm-admin-password"
  key_vault_id = data.azurerm_key_vault.existing.id
}

# Data source for client secret from Key Vault
data "azurerm_key_vault_secret" "client_secret" {
  name         = "terraform-sp-secret"
  key_vault_id = data.azurerm_key_vault.existing.id
}

# Create Resource Group for Databricks
resource "azurerm_resource_group" "databricks" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# Create Virtual Network for Databricks
resource "azurerm_virtual_network" "databricks" {
  name                = "${var.prefix}-vnet-databricks"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.databricks.location
  resource_group_name = azurerm_resource_group.databricks.name

  tags = var.tags
}

# Public Subnet for Databricks
resource "azurerm_subnet" "databricks_public" {
  name                 = "${var.prefix}-subnet-databricks-public"
  resource_group_name  = azurerm_resource_group.databricks.name
  virtual_network_name = azurerm_virtual_network.databricks.name
  address_prefixes     = ["10.1.1.0/24"]

  delegation {
    name = "databricks_delegation"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

# Private Subnet for Databricks
resource "azurerm_subnet" "databricks_private" {
  name                 = "${var.prefix}-subnet-databricks-private"
  resource_group_name  = azurerm_resource_group.databricks.name
  virtual_network_name = azurerm_virtual_network.databricks.name
  address_prefixes     = ["10.1.2.0/24"]

  delegation {
    name = "databricks_delegation"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

# Network Security Group for Databricks
resource "azurerm_network_security_group" "databricks" {
  name                = "${var.prefix}-nsg-databricks"
  location            = azurerm_resource_group.databricks.location
  resource_group_name = azurerm_resource_group.databricks.name

  # Allow access from specific IP (your home IP)
  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = var.allowed_ip_address
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Associate NSG with public subnet
resource "azurerm_subnet_network_security_group_association" "databricks_public" {
  subnet_id                 = azurerm_subnet.databricks_public.id
  network_security_group_id = azurerm_network_security_group.databricks.id
}

# Associate NSG with private subnet
resource "azurerm_subnet_network_security_group_association" "databricks_private" {
  subnet_id                 = azurerm_subnet.databricks_private.id
  network_security_group_id = azurerm_network_security_group.databricks.id
}

# Storage Account for Databricks Data
resource "azurerm_storage_account" "databricks" {
  name                     = "${var.prefix}stgdatabricks${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.databricks.name
  location                 = azurerm_resource_group.databricks.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  # Enable hierarchical namespace for Data Lake Gen2
  is_hns_enabled = true

  tags = var.tags
}

# Random string for storage account name
resource "random_string" "storage_suffix" {
  length  = 4
  special = false
  upper   = false
}

# Storage Container for Data
resource "azurerm_storage_container" "databricks_data" {
  name                  = "databricks-data"
  storage_account_name  = azurerm_storage_account.databricks.name
  container_access_type = "private"
}

# Log Analytics Workspace for monitoring
resource "azurerm_log_analytics_workspace" "databricks" {
  name                = "${var.prefix}-law-databricks"
  location            = azurerm_resource_group.databricks.location
  resource_group_name = azurerm_resource_group.databricks.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}

# Azure Databricks Workspace - PREMIUM TIER for developer features
resource "azurerm_databricks_workspace" "main" {
  name                = "${var.prefix}-databricks-workspace"
  resource_group_name = azurerm_resource_group.databricks.name
  location            = azurerm_resource_group.databricks.location
  sku                 = "premium"  # Premium tier for full features

  custom_parameters {
    no_public_ip                                         = false
    virtual_network_id                                   = azurerm_virtual_network.databricks.id
    private_subnet_name                                  = azurerm_subnet.databricks_private.name
    public_subnet_name                                   = azurerm_subnet.databricks_public.name
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.databricks_public.id
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.databricks_private.id
  }

  tags = var.tags
}

# Configure Databricks Provider
provider "databricks" {
  host = azurerm_databricks_workspace.main.workspace_url
}

# Create cluster policy for cost optimization
resource "databricks_cluster_policy" "cost_optimized" {
  name = "Cost Optimized Policy"
  
  definition = jsonencode({
    "spark_version": {
      "type": "fixed",
      "value": "latest-lts-scala2.12"
    },
    "node_type_id": {
      "type": "fixed",
      "value": "Standard_DS3_v2"
    },
    "driver_node_type_id": {
      "type": "fixed", 
      "value": "Standard_DS3_v2"
    },
    "autotermination_minutes": {
      "type": "fixed",
      "value": 20
    },
    "enable_elastic_disk": {
      "type": "fixed",
      "value": true
    },
    "max_workers": {
      "type": "range",
      "maxValue": 3
    },
    "min_workers": {
      "type": "range",
      "maxValue": 1
    }
  })
}

# Create development cluster with auto-termination
resource "databricks_cluster" "dev_cluster" {
  cluster_name            = "dev-cluster-optimized"
  spark_version           = "latest-lts-scala2.12"
  node_type_id            = "Standard_DS3_v2"
  driver_node_type_id     = "Standard_DS3_v2"
  autotermination_minutes = 20
  
  autoscale {
    min_workers = 1
    max_workers = 2
  }

  azure_attributes {
    availability       = "SPOT_WITH_FALLBACK_AZURE"  # Use spot instances for cost savings
    first_on_demand    = 1
    spot_bid_max_price = -1  # Use current spot price
  }

  policy_id = databricks_cluster_policy.cost_optimized.id

  depends_on = [
    azurerm_databricks_workspace.main
  ]
}