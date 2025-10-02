# Configuração de Resource Groups

## RG rg-blob-br-tsstate-tf-prod
- **Função:** APENAS para estado do Terraform  
- **Contém:** Key Vault + Storage Account para tfstate
- **Acesso:** Service Principal restrito
- **Bloqueado:** ✅ Não deve ser usado para deploy de recursos

## RG rg-dev-sql-vm  
- **Função:** Deploy de recursos (VM, SQL, etc)
- **Contém:** Todos os recursos da aplicação
- **Acesso:** Service Principal com permissões Contributor
- **Deploy:** ✅ Usar este RG para todos os recursos

## Arquitetura

```
┌─────────────────────────────────────┐
│ rg-blob-br-tsstate-tf-prod          │
│ ┌─────────────────────────────────┐ │
│ │ Key Vault (kv-dev-terraform-667)│ │
│ │ - ARM credentials               │ │
│ │ - VM passwords                  │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ Storage Account                 │ │
│ │ (stterraformstate7479)          │ │
│ │ - terraform.tfstate             │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ rg-dev-sql-vm                       │
│ ┌─────────────────────────────────┐ │
│ │ VM Windows                      │ │
│ │ - Standard_B1s                  │ │
│ │ - RDP access                    │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ SQL Server / Database           │ │
│ │ - Menor custo possível          │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ Networking                      │ │
│ │ - VNet, NSG, Public IP          │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

## Service Principal Permissions

```bash
# Ver permissões atuais
az role assignment list --assignee "82034c8e-2909-4846-911e-2205e8f96b9b" --query "[].{Role:roleDefinitionName, Scope:scope}" -o table
```