# Service Principal Scripts

## Pasta com scripts para criar Service Principal

### Arquivos:
- `create-service-principal.ps1` - Script PowerShell
- `create-service-principal.sh` - Script Bash  
- `azure-cli-commands.md` - Comandos manuais

### Como usar:

**PowerShell:**
```powershell
.\scripts\create-service-principal.ps1
```

**Bash:**
```bash
chmod +x scripts/create-service-principal.sh
./scripts/create-service-principal.sh
```

### O que faz:
1. Cria Service Principal para Resource Group: `rg-blob-br-tsstate-tf-prod`
2. Atribui role "Contributor" apenas neste RG
3. Gera arquivo `terraform.env` com credenciais
4. Exibe variáveis para configurar Terraform

### Após executar:
```powershell
# Carregar variáveis
. .\terraform.env  # PowerShell
source terraform.env  # Bash

# Testar Terraform
terraform plan
```