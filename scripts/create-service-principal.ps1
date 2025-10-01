# Script para criar Service Principal com acesso apenas ao Resource Group específico
# Resource Group: rg-blob-br-tsstate-tf-prod

$resourceGroupName = "rg-blob-br-tsstate-tf-prod"
$servicePrincipalName = "sp-terraform-$resourceGroupName"

Write-Host "🔧 Criando Service Principal para Resource Group: $resourceGroupName" -ForegroundColor Green

# 1. Obter informações da subscription
$subscription = az account show --query "{subscriptionId:id, tenantId:tenantId}" -o json | ConvertFrom-Json
Write-Host "📋 Subscription ID: $($subscription.subscriptionId)" -ForegroundColor Yellow

# 2. Obter Resource Group ID
$resourceGroupId = az group show --name $resourceGroupName --query id -o tsv
if (!$resourceGroupId) {
    Write-Host "❌ Resource Group '$resourceGroupName' não encontrado!" -ForegroundColor Red
    exit 1
}
Write-Host "📋 Resource Group ID: $resourceGroupId" -ForegroundColor Yellow

# 3. Criar Service Principal
Write-Host "🔐 Criando Service Principal..." -ForegroundColor Blue
$sp = az ad sp create-for-rbac `
    --name $servicePrincipalName `
    --role "Contributor" `
    --scopes $resourceGroupId `
    --query "{clientId:appId, clientSecret:password, tenantId:tenant}" `
    -o json | ConvertFrom-Json

# 4. Adicionar permissões ao Key Vault
Write-Host "🔑 Adicionando permissões ao Key Vault..." -ForegroundColor Blue
az role assignment create `
    --role "Key Vault Secrets User" `
    --assignee $sp.clientId `
    --scope "$resourceGroupId/providers/Microsoft.KeyVault/vaults/kv-dev-terraform-667"

Write-Host "✅ Service Principal criado com sucesso!" -ForegroundColor Green

# 5. Exibir informações para Terraform
Write-Host ""
Write-Host "🚀 CONFIGURAÇÃO PARA TERRAFORM:" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Adicione as seguintes variáveis de ambiente:" -ForegroundColor White
Write-Host ""
Write-Host "`$env:ARM_CLIENT_ID=`"$($sp.clientId)`"" -ForegroundColor Yellow
Write-Host "`$env:ARM_CLIENT_SECRET=`"$($sp.clientSecret)`"" -ForegroundColor Yellow
Write-Host "`$env:ARM_SUBSCRIPTION_ID=`"$($subscription.subscriptionId)`"" -ForegroundColor Yellow
Write-Host "`$env:ARM_TENANT_ID=`"$($sp.tenantId)`"" -ForegroundColor Yellow
Write-Host ""

# 6. Criar arquivo .env para uso futuro
$envContent = @"
# Azure Service Principal - Terraform
ARM_CLIENT_ID=$($sp.clientId)
ARM_CLIENT_SECRET=$($sp.clientSecret)
ARM_SUBSCRIPTION_ID=$($subscription.subscriptionId)
ARM_TENANT_ID=$($sp.tenantId)
"@

$envContent | Out-File -FilePath "terraform.env" -Encoding UTF8
Write-Host "📁 Arquivo 'terraform.env' criado com as credenciais" -ForegroundColor Green

Write-Host ""
Write-Host "⚠️  IMPORTANTE:" -ForegroundColor Red
Write-Host "- Guarde o CLIENT_SECRET com segurança (não será exibido novamente)" -ForegroundColor Red
Write-Host "- O Service Principal tem acesso APENAS ao Resource Group: $resourceGroupName" -ForegroundColor Red
Write-Host "- Para usar: source terraform.env ou configure as variáveis manualmente" -ForegroundColor Red