#!/bin/bash
# Script para criar Service Principal com acesso apenas ao Resource Group específico
# Resource Group: rg-blob-br-tsstate-tf-prod

RESOURCE_GROUP_NAME="rg-blob-br-tsstate-tf-prod"
SERVICE_PRINCIPAL_NAME="sp-terraform-$RESOURCE_GROUP_NAME"

echo "🔧 Criando Service Principal para Resource Group: $RESOURCE_GROUP_NAME"

# 1. Obter informações da subscription
SUBSCRIPTION_INFO=$(az account show --query "{subscriptionId:id, tenantId:tenantId}" -o json)
SUBSCRIPTION_ID=$(echo $SUBSCRIPTION_INFO | jq -r '.subscriptionId')
TENANT_ID=$(echo $SUBSCRIPTION_INFO | jq -r '.tenantId')
echo "📋 Subscription ID: $SUBSCRIPTION_ID"

# 2. Obter Resource Group ID
RESOURCE_GROUP_ID=$(az group show --name $RESOURCE_GROUP_NAME --query id -o tsv)
if [ -z "$RESOURCE_GROUP_ID" ]; then
    echo "❌ Resource Group '$RESOURCE_GROUP_NAME' não encontrado!"
    exit 1
fi
echo "📋 Resource Group ID: $RESOURCE_GROUP_ID"

# 3. Criar Service Principal
echo "🔐 Criando Service Principal..."
SP_INFO=$(az ad sp create-for-rbac \
    --name $SERVICE_PRINCIPAL_NAME \
    --role "Contributor" \
    --scopes $RESOURCE_GROUP_ID \
    --query "{clientId:appId, clientSecret:password, tenantId:tenant}" \
    -o json)

CLIENT_ID=$(echo $SP_INFO | jq -r '.clientId')
CLIENT_SECRET=$(echo $SP_INFO | jq -r '.clientSecret')
SP_TENANT_ID=$(echo $SP_INFO | jq -r '.tenantId')

echo "✅ Service Principal criado com sucesso!"

# 4. Exibir informações para Terraform
echo ""
echo "🚀 CONFIGURAÇÃO PARA TERRAFORM:"
echo "================================="
echo ""
echo "Adicione as seguintes variáveis de ambiente:"
echo ""
echo "export ARM_CLIENT_ID=\"$CLIENT_ID\""
echo "export ARM_CLIENT_SECRET=\"$CLIENT_SECRET\""
echo "export ARM_SUBSCRIPTION_ID=\"$SUBSCRIPTION_ID\""
echo "export ARM_TENANT_ID=\"$SP_TENANT_ID\""
echo ""

# 5. Criar arquivo .env para uso futuro
cat > terraform.env << EOF
# Azure Service Principal - Terraform
export ARM_CLIENT_ID="$CLIENT_ID"
export ARM_CLIENT_SECRET="$CLIENT_SECRET"
export ARM_SUBSCRIPTION_ID="$SUBSCRIPTION_ID"
export ARM_TENANT_ID="$SP_TENANT_ID"
EOF

echo "📁 Arquivo 'terraform.env' criado com as credenciais"

echo ""
echo "⚠️  IMPORTANTE:"
echo "- Guarde o CLIENT_SECRET com segurança (não será exibido novamente)"
echo "- O Service Principal tem acesso APENAS ao Resource Group: $RESOURCE_GROUP_NAME"
echo "- Para usar: source terraform.env"