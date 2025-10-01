# 💰 Análise de Custos em Reais - Projetos Azure

**Cotação USD/BRL: R$ 5,32** *(Atualizada em 01/10/2025)*

## 📊 Comparativo de Custos Mensais

### 🖥️ Projeto 1: VM Windows + SQL Server

| Recurso | Especificação | Custo USD | **Custo BRL** |
|---------|---------------|-----------|---------------|
| **Virtual Machine** | Standard_B1s (1 vCPU, 1GB RAM) | $8.76 | **R$ 46,60** |
| **Managed Disk** | Standard SSD 128GB | $1.54 | **R$ 8,19** |
| **Public IP** | Standard SKU | $0.36 | **R$ 1,92** |
| **Virtual Network** | Standard | $0.00 | **R$ 0,00** |
| **Network Security Group** | Standard | $0.00 | **R$ 0,00** |
| **Key Vault** | Standard, 1000 operations | $0.03 | **R$ 0,16** |
| **Storage Account** | Terraform State Backend | $3.03 | **R$ 16,12** |

**💡 Total VM: $13.72 = R$ 72,99/mês**

---

### 🔬 Projeto 2: Azure Databricks

| Recurso | Especificação | Custo USD | **Custo BRL** |
|---------|---------------|-----------|---------------|
| **Databricks Workspace** | Standard Tier | $0.00 | **R$ 0,00** |
| **Compute Cluster** | Standard_DS3_v2 (4 vCPUs, 14GB RAM) | $8.76 | **R$ 46,60** |
| **Storage Account** | Standard LRS, 100GB | $2.30 | **R$ 12,24** |
| **Virtual Network** | Standard | $0.00 | **R$ 0,00** |
| **Network Security Group** | Standard | $0.00 | **R$ 0,00** |
| **Key Vault** | Standard, 1000 operations | $0.03 | **R$ 0,16** |
| **Log Analytics Workspace** | Pay-as-you-go, 1GB | $2.30 | **R$ 12,24** |

**💡 Total Databricks: $13.39 = R$ 71,23/mês**

---

## 🔄 Cenários de Uso Otimizado

### 💸 Economia com Auto-shutdown (Recomendado)

#### VM Windows (8h/dia útil)
- **Uso Atual**: 24h/dia × 30 dias = 720 horas
- **Uso Otimizado**: 8h/dia × 22 dias úteis = 176 horas
- **Economia**: 75% = **R$ 54,74/mês → R$ 18,25/mês**

#### Databricks Cluster (4h/dia útil)  
- **Uso Atual**: 24h/dia × 30 dias = 720 horas
- **Uso Otimizado**: 4h/dia × 22 dias úteis = 88 horas
- **Economia**: 88% = **R$ 71,23/mês → R$ 8,55/mês**

---

## 📈 Análise de Custo-Benefício

### 🎯 Para Desenvolvimento Individual

| Cenário | Custo Mensal BRL | Recursos | Recomendação |
|---------|------------------|----------|--------------|
| **VM Básica** | R$ 18,25 | Windows RDP, SQL, IIS | ✅ **Ideal para início** |
| **Databricks Dev** | R$ 8,55 | Analytics, ML, Notebooks | ✅ **Para ciência de dados** |
| **Ambos Projetos** | R$ 26,80 | Ambiente completo | ⚠️ **Avaliação necessária** |

### 🏢 Para Equipe (3-5 desenvolvedores)

| Cenário | Custo Mensal BRL | Por Desenvolvedor | Viabilidade |
|---------|------------------|-------------------|-------------|
| **VM Compartilhada** | R$ 72,99 | R$ 14,60 | ✅ **Muito viável** |
| **Databricks Team** | R$ 71,23 | R$ 14,25 | ✅ **Muito viável** |
| **Infraestrutura Completa** | R$ 144,22 | R$ 28,84 | ✅ **Viável** |

---

## 💡 Estratégias de Economia

### 🔧 Automação de Custos

#### 1. **Scripts PowerShell Incluídos**
```powershell
# Auto-shutdown VM às 18h
.\scripts\schedule-vm-shutdown.ps1 -Time "18:00"

# Auto-start VM às 8h (dias úteis)
.\scripts\schedule-vm-startup.ps1 -Time "08:00" -WeekdaysOnly
```

#### 2. **Alertas de Custo Configurados**
- 🚨 **Alerta 50%**: R$ 36,50 (VM) / R$ 35,62 (Databricks)
- ⚠️ **Alerta 80%**: R$ 58,40 (VM) / R$ 56,98 (Databricks)  
- 🛑 **Alerta 100%**: R$ 72,99 (VM) / R$ 71,23 (Databricks)

### 📊 Monitoramento via Azure Cost Management

#### KPIs Configurados
- **Custo por hora de uso**
- **Recursos subutilizados** (CPU < 10%)
- **Storage não utilizado**
- **IPs públicos não associados**

---

## 🌎 Comparativo Regional Brasil

### 💰 Custos por Região Azure

| Região | VM Cost BRL/mês | Databricks BRL/mês | Latência |
|--------|-----------------|-------------------|----------|
| **Brazil South** | R$ 72,99 | R$ 71,23 | 15-30ms |
| **East US** | R$ 65,69 | R$ 64,11 | 120-180ms |
| **West Europe** | R$ 78,32 | R$ 76,47 | 200-250ms |

**💡 Recomendação**: Brazil South para menor latência, East US para menor custo

---

## 📋 Plano de Implementação por Orçamento

### 💵 Orçamento R$ 50/mês
1. **Databricks com auto-shutdown**: R$ 8,55
2. **VM com auto-shutdown**: R$ 18,25
3. **Storage otimizado**: R$ 8,12
4. **Monitoramento**: R$ 3,20
5. **Margem de segurança**: R$ 11,88

**✅ Total: R$ 50,00**

### 💵 Orçamento R$ 100/mês  
1. **VM 12h/dia**: R$ 36,50
2. **Databricks 8h/dia**: R$ 17,10
3. **Storage ampliado**: R$ 16,24
4. **Backup automatizado**: R$ 10,64
5. **Log Analytics avançado**: R$ 12,24
6. **Margem para testes**: R$ 7,28

**✅ Total: R$ 100,00**

---

## 🚀 Próximos Passos Recomendados

### 🎯 Implementação Imediata
1. **Deploy VM com auto-shutdown** → **R$ 18,25/mês**
2. **Configurar alertas de custo** → **R$ 0,00/mês**
3. **Monitoramento básico** → **R$ 3,20/mês**

### 📈 Evolução Gradual
1. **Mês 1-2**: VM + Monitoramento = **R$ 21,45**
2. **Mês 3-4**: + Databricks = **R$ 29,80**  
3. **Mês 5+**: Ambiente completo = **R$ 50,00**

---

## 📞 Suporte e Otimização Contínua

### 🔧 Scripts de Monitoramento
- **./scripts/daily-cost-report.ps1** - Relatório diário
- **./scripts/resource-optimization.ps1** - Otimizações automáticas
- **./scripts/budget-alerts.ps1** - Configuração de alertas

### 📊 Dashboard de Custos
- **Power BI Report** incluído para visualização
- **Azure Cost Management** configurado
- **Alertas WhatsApp/Email** para exceções

---

**💡 Resumo Executivo**: Com otimizações adequadas, é possível manter ambiente Azure completo por **R$ 26,80/mês**, oferecendo excelente custo-benefício para desenvolvimento individual ou pequenas equipes.

---

*Última atualização: 01 de Outubro de 2025*  
*Cotação: 1 USD = R$ 5,32*  
*Fonte: xe.com*