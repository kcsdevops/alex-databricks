# Comandos Azure CLI para Service Principal

## 1. Listar Resource Groups (verificar se existe)
```bash
az group list --query "[].{Name:name, Location:location}" -o table
```

## 2. Verificar Resource Group específico
```bash
az group show --name "rg-blob-br-tsstate-tf-prod" --query "{Name:name, Id:id, Location:location}" -o table
```

## 3. Criar Service Principal manualmente
```bash
# Obter Resource Group ID
RG_ID=$(az group show --name "rg-blob-br-tsstate-tf-prod" --query id -o tsv)

# Criar Service Principal com acesso apenas ao RG
az ad sp create-for-rbac \
  --name "sp-terraform-rg-blob-br-tsstate-tf-prod" \
  --role "Contributor" \
  --scopes $RG_ID
```

## 4. Listar Service Principals criados
```bash
az ad sp list --display-name "sp-terraform-rg-blob-br-tsstate-tf-prod" --query "[].{DisplayName:displayName, AppId:appId}" -o table
```

## 5. Verificar permissões do Service Principal
```bash
# Substituir {APP_ID} pelo appId retornado
az role assignment list --assignee {APP_ID} --query "[].{Role:roleDefinitionName, Scope:scope}" -o table
```

## 6. Deletar Service Principal (se necessário)
```bash
az ad sp delete --id {APP_ID}
```

## 7. Variáveis de ambiente para Terraform
```powershell
# PowerShell
$env:ARM_CLIENT_ID="seu-client-id"
$env:ARM_CLIENT_SECRET="seu-client-secret"  
$env:ARM_SUBSCRIPTION_ID="sua-subscription-id"
$env:ARM_TENANT_ID="seu-tenant-id"
```

```bash
# Bash
export ARM_CLIENT_ID="seu-client-id"
export ARM_CLIENT_SECRET="seu-client-secret"
export ARM_SUBSCRIPTION_ID="sua-subscription-id"
export ARM_TENANT_ID="seu-tenant-id"
```