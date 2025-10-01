# VM W**Configuração:**
- Tamanho: Standard_B1s (1 vCPU, 1GB RAM) - ~$7.50/mês
- OS: Windows Server 2022
- Disco: 30GB Standard HDD
- Região: Brazil South

**Arquitetura:**
- **RG Estado:** `rg-blob-br-tsstate-tf-prod` (Key Vault + tfstate)
- **RG Deploy:** `rg-dev-sql-vm` (VM, SQL, networking)
- **Backend:** Azure Storage para estado remoto

**Segurança:**
- Key Vault: `kv-dev-terraform-667`
- Credenciais armazenadas com segurança
- Service Principal com acesso restrito

**Acesso:**
- Usuário: `devadmin`
- Senha: Armazenada no Key Vault
- RDP: Apenas seu IP (177.214.188.64)Ambiente DEV

Terraform para VM Windows no Azure com menor custo possível + Key Vault para segurança.

## Configuração

**VM Specs:**
- Tamanho: Standard_B1s (1 vCPU, 1GB RAM) - ~$7.50/mês
- OS: Windows Server 2022
- Disco: 30GB Standard HDD
- Região: East US (menor custo)

**Segurança:**
- Key Vault: `kv-dev-terraform-667`
- Credenciais armazenadas com segurança
- Service Principal com acesso restrito

**Acesso:**
- Usuário: `devadmin`
- Senha: Armazenada no Key Vault
- RDP: Apenas seu IP (177.214.188.64)

## Deploy

```powershell
# 1. Carregar credenciais do Key Vault
.\scripts\load-credentials.ps1

# 2. Inicializar Terraform
terraform init

# 3. Planejar
terraform plan

# 4. Aplicar
terraform apply -auto-approve

# 5. Ver outputs
terraform output
```

## Conectar

```bash
# Comando RDP será exibido no output
terraform output rdp_command

# Senha da VM
terraform output vm_password
```

## Key Vault

```powershell
# Listar secrets
az keyvault secret list --vault-name "kv-dev-terraform-667" --query "[].name" -o table

# Ver secret específico
az keyvault secret show --vault-name "kv-dev-terraform-667" --name "vm-admin-password" --query value -o tsv
```

## Destruir

```powershell
terraform destroy -auto-approve
```