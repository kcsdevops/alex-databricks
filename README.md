# 🚀 ALEPROJ - Azure Infrastructure Projects

## 📋 Visão Geral

Este repositório contém dois projetos Azure independentes, otimizados para desenvolvimento com foco em economia de custos.

## 📁 Estrutura dos Projetos

### 🖥️ [Azure VM Project](./azure-vm-project/)
**Windows Server com SQL Server para desenvolvimento**

- **Recursos**: VM Standard_B1s, SQL Server, RDP habilitado
- **Custo**: ~R$ 72.99/mês (R$ 18.25 com auto-shutdown)
- **Ideal para**: Desenvolvimento .NET, aplicações Windows

### 🔬 [Azure Databricks Project](./azure-databricks-project/) 
**Ambiente Analytics para Ciência de Dados**

- **Recursos**: Databricks Premium, Cluster otimizado, Data Lake
- **Custo**: ~R$ 71.23/mês (R$ 8.55 com auto-shutdown)
- **Trial**: 14 dias gratuitos Premium tier
- **Ideal para**: Analytics, Machine Learning, Big Data

## 💰 Análise de Custos Consolidada

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