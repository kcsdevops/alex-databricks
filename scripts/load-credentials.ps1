# Script para carregar credenciais do Key Vault
$keyVaultName = "kv-dev-terraform-667"

Write-Host "🔑 Carregando credenciais do Key Vault: $keyVaultName" -ForegroundColor Green

# Carregar secrets do Key Vault
$clientId = az keyvault secret show --vault-name $keyVaultName --name "ARM-CLIENT-ID" --query value -o tsv
$clientSecret = az keyvault secret show --vault-name $keyVaultName --name "ARM-CLIENT-SECRET" --query value -o tsv
$subscriptionId = az keyvault secret show --vault-name $keyVaultName --name "ARM-SUBSCRIPTION-ID" --query value -o tsv
$tenantId = az keyvault secret show --vault-name $keyVaultName --name "ARM-TENANT-ID" --query value -o tsv

# Definir variáveis de ambiente
$env:ARM_CLIENT_ID = $clientId
$env:ARM_CLIENT_SECRET = $clientSecret
$env:ARM_SUBSCRIPTION_ID = $subscriptionId
$env:ARM_TENANT_ID = $tenantId

Write-Host "✅ Credenciais carregadas com sucesso!" -ForegroundColor Green
Write-Host "📋 Client ID: $clientId" -ForegroundColor Yellow
Write-Host "📋 Subscription ID: $subscriptionId" -ForegroundColor Yellow
Write-Host "📋 Tenant ID: $tenantId" -ForegroundColor Yellow
Write-Host ""
Write-Host "🚀 Pronto para usar Terraform!" -ForegroundColor Cyan