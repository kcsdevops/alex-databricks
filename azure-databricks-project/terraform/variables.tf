# Variables for Azure Databricks project
variable "prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "Brazil South"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-databricks-dev"
}

variable "key_vault_name" {
  description = "Name of the existing Key Vault"
  type        = string
  default     = "kv-dev-terraform-667"
}

variable "key_vault_resource_group" {
  description = "Resource group of the existing Key Vault"
  type        = string
  default     = "rg-dev-sql-vm"
}

variable "allowed_ip_address" {
  description = "Your home IP address for secure access"
  type        = string
  default     = "177.214.188.64/32"  # Replace with your actual IP
}

variable "databricks_sku" {
  description = "Databricks workspace SKU - standard or premium"
  type        = string
  default     = "premium"
  
  validation {
    condition     = contains(["standard", "premium"], var.databricks_sku)
    error_message = "Databricks SKU must be either 'standard' or 'premium'."
  }
}

variable "auto_termination_minutes" {
  description = "Auto-termination time for clusters in minutes"
  type        = number
  default     = 20
}

variable "max_workers" {
  description = "Maximum number of workers for auto-scaling clusters"
  type        = number
  default     = 2
}

variable "min_workers" {
  description = "Minimum number of workers for auto-scaling clusters"
  type        = number
  default     = 1
}

variable "cluster_node_type" {
  description = "Node type for Databricks clusters"
  type        = string
  default     = "Standard_DS3_v2"  # 4 vCPUs, 14GB RAM - cost optimized
}

variable "use_spot_instances" {
  description = "Use spot instances for cost savings"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment   = "Development"
    Project       = "Databricks-Analytics"
    Owner         = "DevTeam"
    CostCenter    = "Engineering"
    AutoShutdown  = "Enabled"
  }
}