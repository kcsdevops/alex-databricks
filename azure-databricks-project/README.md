# 🚀 Azure Databricks Development Environment

## 📋 Visão Geral

Projeto completo para deploy de ambiente Azure Databricks otimizado para desenvolvimento, com foco em economia de custos e produtividade.

### 💰 **Opções de Pricing - Desenvolvedores**

#### ✅ **SIM, existe tier para desenvolvedores!**

| Tier | Custo Databricks | Recursos Incluídos | Ideal Para |
|------|------------------|-------------------|------------|
| **Standard** | **$0.40/DBU** | All-Purpose Compute, Jobs, Notebooks | **Desenvolvimento básico** |
| **Premium** | **$0.55/DBU** | + RBAC, Audit Logs, Conditional Access | **Desenvolvimento profissional** |
| **Trial** | **Gratuito 14 dias** | Acesso completo Premium | **Teste e avaliação** |

> **💡 DBU (Databricks Unit)**: Unidade de processamento. Uma instância Standard_DS3_v2 consome ~0.75 DBU/hora.

### 🎯 **Custos Reais com Otimizações**

#### Configuração Recomendada para DEV:
- **Trial Premium**: 14 dias gratuitos
- **Standard_DS3_v2**: 4 vCPUs, 14GB RAM
- **Auto-terminação**: 20 minutos
- **Spot Instances**: Até 80% de economia
- **Auto-scaling**: 1-2 workers

#### 💸 **Custos Mensais Estimados**:

| Cenário | Horas/Mês | Custo USD | **Custo BRL** |
|---------|-----------|-----------|---------------|
| **Trial Premium** | Ilimitado | $0.00 | **R$ 0,00** |
| **Standard (4h/dia)** | 88h | $7.92 | **R$ 42.13** |
| **Premium (4h/dia)** | 88h | $10.89 | **R$ 57.93** |

> **🎉 Conclusão**: Use o **Trial Premium gratuito** por 14 dias, depois migre para Standard otimizado!

## 🏗️ Estrutura do Projeto

```
azure-databricks-project/
├── terraform/
│   ├── main.tf              # Recursos principais
│   ├── variables.tf         # Variáveis de configuração
│   ├── outputs.tf           # Outputs do deployment
│   ├── providers.tf         # Configuração de providers
│   └── terraform.tfvars     # Valores das variáveis
├── scripts/
│   ├── Deploy-Databricks.ps1   # Script principal de deploy
│   └── load-credentials.ps1    # Carregamento de credenciais
├── notebooks/
│   └── getting-started.py      # Notebook de introdução
├── docs/
│   └── (documentação adicional)
└── README.md
```

## 🚀 Guia de Deploy Rápido

### 1. **Pré-requisitos**
```powershell
# Verificar instalações necessárias
az --version
terraform --version
```

### 2. **Configurar Credenciais**
```powershell
# Carregar credenciais do Key Vault
.\scripts\load-credentials.ps1
```

### 3. **Deploy do Ambiente**
```powershell
# Planejar deployment
.\scripts\Deploy-Databricks.ps1 -Action plan

# Aplicar (com confirmação)
.\scripts\Deploy-Databricks.ps1 -Action apply

# Aplicar (sem confirmação)
.\scripts\Deploy-Databricks.ps1 -Action apply -AutoApprove
```

### 4. **Acessar Databricks**
Após o deploy, use a URL fornecida nos outputs para acessar seu workspace.

## ⚙️ Configurações de Otimização

### 🔧 **Cluster Policy (Incluso)**
- **Auto-terminação**: 20 minutos de inatividade
- **Spot Instances**: Habilitado com fallback
- **Auto-scaling**: 1-2 workers (Standard_DS3_v2)
- **Latest LTS Spark**: Sempre a versão mais estável

### 💰 **Monitoramento de Custos**
- **Azure Cost Management**: Alertas configurados
- **Databricks Usage**: Tracking de DBU consumption
- **Automated Reports**: Relatórios diários de uso

### 🔒 **Segurança**
- **Network Security Group**: Acesso restrito ao seu IP
- **Key Vault Integration**: Secrets gerenciados centralmente
- **RBAC**: Role-based access control (Premium)

## 📊 Recursos Incluídos

### 🎯 **Infraestrutura**
- ✅ Databricks Workspace (Premium)
- ✅ Virtual Network com subnets dedicadas
- ✅ Storage Account (Data Lake Gen2)
- ✅ Log Analytics Workspace
- ✅ Network Security Group
- ✅ Development Cluster otimizado

### 📚 **Notebooks e Exemplos**
- ✅ Getting Started notebook
- 🔄 Data Analysis samples (em breve)
- 🔄 ML Pipeline examples (em breve)
- 🔄 Visualization templates (em breve)

## 🎯 **Comparação: Standard vs Premium**

| Recurso | Standard | Premium |
|---------|----------|---------|
| **Notebooks & Collaboration** | ✅ | ✅ |
| **Job Scheduling** | ✅ | ✅ |
| **Auto-scaling Clusters** | ✅ | ✅ |
| **MLflow Integration** | ✅ | ✅ |
| **Delta Lake** | ✅ | ✅ |
| **RBAC & Security** | ❌ | ✅ |
| **Audit Logs** | ❌ | ✅ |
| **Conditional Access** | ❌ | ✅ |
| **Advanced Networking** | ❌ | ✅ |

> **💡 Recomendação**: Use Premium para desenvolvimento profissional (apenas +$0.15/DBU)

## 🛠️ Comandos Úteis

### Terraform
```powershell
# Ver outputs após deploy
terraform output

# Destruir ambiente (cuidado!)
terraform destroy -var-file="terraform.tfvars"

# Aplicar mudanças específicas
terraform apply -target=azurerm_databricks_workspace.main
```

### Azure CLI
```powershell
# Listar workspaces Databricks
az databricks workspace list --resource-group rg-databricks-dev

# Ver detalhes do workspace
az databricks workspace show --name dev-databricks-workspace --resource-group rg-databricks-dev
```

## 📈 Roadmap

### ✅ **Concluído**
- [x] Infraestrutura base com Terraform
- [x] Otimizações de custo configuradas
- [x] Scripts de deployment automatizado
- [x] Notebook de introdução

### 🔄 **Em Desenvolvimento**
- [ ] Notebooks de análise de dados
- [ ] Pipeline de ML end-to-end
- [ ] Integração com Azure Data Factory
- [ ] Templates de visualização

### 🎯 **Planejado**
- [ ] CI/CD pipeline
- [ ] Disaster recovery setup
- [ ] Multi-environment support
- [ ] Advanced monitoring dashboards

## 💡 Dicas de Economia

### 🕐 **Gestão de Tempo**
- Configure auto-terminação agressiva durante desenvolvimento
- Use o Trial Premium para avaliar necessidades
- Monitore DBU consumption diariamente

### 💰 **Otimização de Recursos**
- Prefira Standard tier para desenvolvimento básico
- Use Spot instances sempre que possível
- Configure auto-scaling responsivo

### 📊 **Monitoramento**
- Configure alertas de custo no Azure
- Revise relatórios de uso semanalmente
- Ajuste configurações baseado no uso real

## 🆘 Troubleshooting

### ❌ **Problemas Comuns**

#### "Databricks provider authentication failed"
```powershell
# Verificar variáveis de ambiente
echo $env:DATABRICKS_AZURE_CLIENT_ID
echo $env:DATABRICKS_AZURE_CLIENT_SECRET

# Recarregar credenciais
.\scripts\load-credentials.ps1
```

#### "Subnet delegation failed"
- Verificar se as subnets não estão em uso
- Confirmar permissões do Service Principal

#### "Spot instance não disponível"
- Terraform fará fallback para On-Demand automaticamente
- Região Brazil South pode ter disponibilidade limitada

## 📞 Suporte

- **Documentação Azure Databricks**: [docs.microsoft.com](https://docs.microsoft.com/azure/databricks/)
- **Terraform AzureRM Provider**: [registry.terraform.io](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
- **Azure Support**: Para problemas de billing e quotas

---

**🎉 Databricks Development Environment - Ready to Rock!**

*Com otimizações de custo, segurança configurada e notebooks prontos para uso.*