output "vm_public_ip" {
  value = azurerm_public_ip.dev.ip_address
}

output "vm_username" {
  value = "devadmin"
}

output "vm_password" {
  value = data.azurerm_key_vault_secret.vm_admin_password.value
  sensitive = true
}

output "key_vault_name" {
  value = data.azurerm_key_vault.terraform_kv.name
}

output "key_vault_uri" {
  value = data.azurerm_key_vault.terraform_kv.vault_uri
}

output "rdp_command" {
  value = "mstsc /v:${azurerm_public_ip.dev.ip_address}"
}