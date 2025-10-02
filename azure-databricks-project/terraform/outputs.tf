# Output values for Databricks deployment
output "databricks_workspace_id" {
  description = "ID of the Databricks workspace"
  value       = azurerm_databricks_workspace.main.id
}

output "databricks_workspace_url" {
  description = "URL of the Databricks workspace"
  value       = "https://${azurerm_databricks_workspace.main.workspace_url}"
}

output "databricks_workspace_name" {
  description = "Name of the Databricks workspace"
  value       = azurerm_databricks_workspace.main.name
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.databricks.name
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.databricks.name
}

output "storage_account_primary_endpoint" {
  description = "Primary endpoint of the storage account"
  value       = azurerm_storage_account.databricks.primary_dfs_endpoint
}

output "virtual_network_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.databricks.id
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.databricks.id
}

output "cluster_id" {
  description = "ID of the development cluster"
  value       = databricks_cluster.dev_cluster.id
  sensitive   = true
}

output "cluster_name" {
  description = "Name of the development cluster"
  value       = databricks_cluster.dev_cluster.cluster_name
}

output "estimated_monthly_cost_usd" {
  description = "Estimated monthly cost in USD"
  value       = "~$13.39 (with auto-termination and spot instances)"
}

output "estimated_monthly_cost_brl" {
  description = "Estimated monthly cost in BRL"
  value       = "~R$ 71.23 (cotação R$ 5.32/USD)"
}

output "cost_optimization_notes" {
  description = "Cost optimization features enabled"
  value = [
    "Auto-termination after 20 minutes of inactivity",
    "Spot instances with fallback to on-demand",
    "Auto-scaling between 1-2 workers",
    "Premium tier for full development features",
    "Standard_DS3_v2 instances for optimal cost/performance"
  ]
}