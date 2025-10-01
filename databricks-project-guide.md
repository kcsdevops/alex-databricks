# Azure Databricks Development Environment

## 📋 Visão Geral

Este projeto configura um ambiente de desenvolvimento Azure Databricks otimizado para custos, incluindo workspace, cluster e recursos de armazenamento necessários para análise de dados e machine learning.

## 💰 Análise de Custos

### Custos Mensais Estimados (Região Brazil South)

| Recurso | Especificação | Custo Mensal (USD) |
|---------|---------------|-------------------|
| **Databricks Workspace** | Standard Tier | $0.00 |
| **Compute Cluster** | Standard_DS3_v2 (4 vCPUs, 14GB RAM) | $8.76 |
| **Storage Account** | Standard LRS, 100GB | $2.30 |
| **Virtual Network** | Standard | $0.00 |
| **Network Security Group** | Standard | $0.00 |
| **Key Vault** | Standard, 1000 operations | $0.03 |
| **Log Analytics Workspace** | Pay-as-you-go, 1GB | $2.30 |

**💡 Total Estimado: $13.39/mês**

### Estratégias de Otimização de Custos

#### 🔄 Auto-terminação de Cluster
- **Configuração**: Cluster termina automaticamente após 20 minutos de inatividade
- **Economia**: Até 70% dos custos de compute
- **Implementação**: Configurado via Terraform

#### 📊 Monitoramento de Uso
- **Log Analytics**: Rastreamento detalhado de uso de recursos
- **Alertas**: Notificações quando custos excedem limites
- **Relatórios**: Análise mensal de consumo

#### 🎯 Cluster Spot Instances
- **Disponibilidade**: Sujeito à disponibilidade Azure
- **Economia**: Até 80% de desconto vs. instâncias regulares
- **Configuração**: Habilitado no arquivo Terraform

## 🏗️ Arquitetura da Solução

```
┌─────────────────────────────────────────────────────────────┐
│                    Azure Subscription                       │
├─────────────────────────────────────────────────────────────┤
│  Resource Group: rg-databricks-dev                         │
│                                                             │
│  ┌─────────────────┐    ┌─────────────────┐               │
│  │  Databricks     │    │   Key Vault     │               │
│  │   Workspace     │◄───┤   Secrets       │               │
│  │                 │    │                 │               │
│  └─────────────────┘    └─────────────────┘               │
│           │                                                │
│           ▼                                                │
│  ┌─────────────────┐    ┌─────────────────┐               │
│  │   Compute       │    │   Storage       │               │
│  │   Cluster       │◄───┤   Account       │               │
│  │  (Auto-scale)   │    │   (Data Lake)   │               │
│  └─────────────────┘    └─────────────────┘               │
│           │                       │                        │
│           ▼                       ▼                        │
│  ┌─────────────────┐    ┌─────────────────┐               │
│  │   Virtual       │    │   Network       │               │
│  │   Network       │◄───┤   Security      │               │
│  │                 │    │   Group         │               │
│  └─────────────────┘    └─────────────────┘               │
└─────────────────────────────────────────────────────────────┘
```

## 🚀 Guia de Implantação

### Pré-requisitos

1. **Azure CLI** instalado e configurado
2. **Terraform** >= 1.0
3. **Service Principal** com permissões adequadas
4. **Key Vault** configurado (do projeto anterior)

### Passos de Implantação

#### 1. Configurar Credenciais
```powershell
# Executar script de carregamento de credenciais
.\scripts\load-credentials.ps1
```

#### 2. Inicializar Terraform
```powershell
cd databricks-project
terraform init
```

#### 3. Planejar Implantação
```powershell
terraform plan -var-file="terraform.tfvars"
```

#### 4. Aplicar Configuração
```powershell
terraform apply -var-file="terraform.tfvars" -auto-approve
```

#### 5. Configurar Cluster
```powershell
# Executar configuração automática do cluster
.\scripts\configure-databricks-cluster.ps1
```

## 📁 Estrutura do Projeto

```
databricks-project/
├── terraform/
│   ├── main.tf                 # Recursos principais
│   ├── variables.tf            # Variáveis de configuração
│   ├── outputs.tf              # Outputs do Terraform
│   ├── terraform.tfvars        # Valores das variáveis
│   └── providers.tf            # Configuração de providers
├── scripts/
│   ├── configure-databricks-cluster.ps1
│   ├── setup-notebooks.ps1
│   └── cost-monitoring.ps1
├── notebooks/
│   ├── getting-started.py      # Notebook de introdução
│   ├── data-analysis-sample.py # Exemplo de análise
│   └── ml-pipeline-example.py  # Pipeline de ML
└── docs/
    ├── cluster-configuration.md
    └── best-practices.md
```

## 🔧 Configurações do Cluster

### Especificações Padrão
- **Tipo**: Standard_DS3_v2
- **Cores**: 4 vCPUs
- **RAM**: 14 GB
- **Auto-scaling**: 1-3 workers
- **Auto-terminação**: 20 minutos

### Configurações de Segurança
- **Network Security Group**: Acesso restrito ao IP 177.214.188.64/32
- **Key Vault Integration**: Secrets gerenciados centralmente
- **Encryption**: Dados em trânsito e em repouso

## 📊 Notebooks Incluídos

### 1. Getting Started (`notebooks/getting-started.py`)
- Introdução ao Databricks
- Configuração inicial
- Teste de conectividade

### 2. Data Analysis Sample (`notebooks/data-analysis-sample.py`)
- Análise exploratória de dados
- Visualizações com matplotlib/seaborn
- Operações com Spark DataFrames

### 3. ML Pipeline Example (`notebooks/ml-pipeline-example.py`)
- Pipeline de Machine Learning
- Preprocessamento de dados
- Treinamento e avaliação de modelos

## 📈 Monitoramento e Alertas

### Log Analytics Queries

#### Uso de Cluster por Hora
```kusto
DatabricksClusterEvents
| where TimeGenerated > ago(24h)
| summarize UsageHours = count() by bin(TimeGenerated, 1h)
| render timechart
```

#### Custos por Recurso
```kusto
DatabricksClusters
| summarize TotalCost = sum(Cost) by ClusterName
| order by TotalCost desc
```

### Alertas Configurados

1. **Alto Uso de Cluster** - Dispara quando cluster executa > 8 horas/dia
2. **Custo Mensal** - Alerta quando custos excedem $15/mês
3. **Falha de Jobs** - Notificação imediata para jobs falhados

## 🔍 Solução de Problemas

### Problemas Comuns

#### 1. Cluster não Inicia
```bash
# Verificar status do workspace
az databricks workspace show --resource-group rg-databricks-dev --name databricks-workspace-dev

# Verificar logs do cluster
databricks clusters get --cluster-id <cluster-id>
```

#### 2. Problemas de Conectividade
```bash
# Verificar NSG rules
az network nsg rule list --resource-group rg-databricks-dev --nsg-name nsg-databricks-dev
```

#### 3. Erros de Autenticação
```bash
# Verificar Service Principal
az ad sp show --id 82034c8e-2909-4846-911e-2205e8f96b9b
```

## 🎯 Próximos Passos

1. **Deploy da Infraestrutura**: Executar terraform apply
2. **Configurar Notebooks**: Importar notebooks de exemplo
3. **Setup de Monitoramento**: Configurar dashboards no Azure Monitor
4. **Testes de Performance**: Executar benchmarks iniciais
5. **Documentação**: Criar guias específicos para equipe

## 📞 Suporte

Para problemas ou dúvidas:
1. Verificar logs no Azure Portal
2. Consultar documentação oficial do Databricks
3. Revisar configurações do Terraform
4. Verificar permissões do Service Principal

---

**Última Atualização**: Outubro 2025  
**Versão**: 1.0  
**Autor**: DevOps Team