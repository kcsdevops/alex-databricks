# Troubleshoot - Permissões Key Vault

## Problema Resolvido
✅ **Error 403 - Service Principal sem acesso ao Key Vault**

## Solução Aplicada
```powershell
# Adicionar role "Key Vault Secrets User" ao Service Principal
az role assignment create \
  --role "Key Vault Secrets User" \
  --assignee "82034c8e-2909-4846-911e-2205e8f96b9b" \
  --scope "/subscriptions/ea0648dc-2e7b-44c2-a2fb-d5bac8b03c24/resourceGroups/rg-blob-br-tsstate-tf-prod/providers/Microsoft.KeyVault/vaults/kv-dev-terraform-667"
```

## Verificar Permissões
```powershell
# Listar roles do Service Principal
az role assignment list --assignee "82034c8e-2909-4846-911e-2205e8f96b9b" --query "[].{Role:roleDefinitionName, Scope:scope}" -o table

# Testar acesso ao secret
az keyvault secret show --vault-name "kv-dev-terraform-667" --name "vm-admin-password" --query value -o tsv
```

## Roles Necessárias
- **Contributor** nos Resource Groups
- **Key Vault Secrets User** no Key Vault

## Status Atual
- ✅ Service Principal criado
- ✅ Permissões nos RGs
- ✅ Permissões no Key Vault
- ✅ Terraform funcionando

## Próximos Passos
```powershell
.\scripts\load-credentials.ps1
terraform apply -auto-approve
```