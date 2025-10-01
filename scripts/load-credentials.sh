#!/bin/bash
# Script para carregar credenciais do Key Vault
KEY_VAULT_NAME="kv-dev-terraform-667"

echo "🔑 Carregando credenciais do Key Vault: $KEY_VAULT_NAME"

# Carregar secrets do Key Vault
CLIENT_ID=$(az keyvault secret show --vault-name $KEY_VAULT_NAME --name "ARM-CLIENT-ID" --query value -o tsv)
CLIENT_SECRET=$(az keyvault secret show --vault-name $KEY_VAULT_NAME --name "ARM-CLIENT-SECRET" --query value -o tsv)
SUBSCRIPTION_ID=$(az keyvault secret show --vault-name $KEY_VAULT_NAME --name "ARM-SUBSCRIPTION-ID" --query value -o tsv)
TENANT_ID=$(az keyvault secret show --vault-name $KEY_VAULT_NAME --name "ARM-TENANT-ID" --query value -o tsv)

# Definir variáveis de ambiente
export ARM_CLIENT_ID=$CLIENT_ID
export ARM_CLIENT_SECRET=$CLIENT_SECRET
export ARM_SUBSCRIPTION_ID=$SUBSCRIPTION_ID
export ARM_TENANT_ID=$TENANT_ID

echo "✅ Credenciais carregadas com sucesso!"
echo "📋 Client ID: $CLIENT_ID"
echo "📋 Subscription ID: $SUBSCRIPTION_ID"
echo "📋 Tenant ID: $TENANT_ID"
echo ""
echo "🚀 Pronto para usar Terraform!"