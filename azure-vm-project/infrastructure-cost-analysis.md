# Análise de Custos - Infraestrutura Azure DEV

## 📊 Resumo dos Recursos Criados

### ✅ Implantados com Sucesso
- ✅ **VM Windows**: `vm-dev` (Standard_B1s)
- ✅ **IP Público**: `172.172.131.31` (Standard SKU)
- ✅ **Virtual Network**: `vnet-dev` (10.0.0.0/16)
- ✅ **Network Security Group**: RDP apenas IP casa
- ✅ **Key Vault**: Credenciais seguras
- ✅ **Storage Account**: Estado do Terraform

## 💰 Estimativa de Custos Mensais (USD)

### Recursos de Produção (rg-dev-sql-vm)
| Recurso | Tipo | Região | Custo/Mês |
|---------|------|--------|-----------|
| **VM Windows** | Standard_B1s | East US | $7.88 |
| **OS Disk** | Standard HDD 30GB | East US | $1.54 |
| **Public IP** | Standard SKU | East US | $3.65 |
| **VNet** | Virtual Network | East US | $0.00 |
| **NSG** | Network Security Group | East US | $0.00 |
| **NIC** | Network Interface | East US | $0.00 |

**Subtotal Recursos Produção: ~$13.07/mês**

### Recursos de Estado (rg-blob-br-tsstate-tf-prod)
| Recurso | Tipo | Região | Custo/Mês |
|---------|------|--------|-----------|
| **Key Vault** | Standard | Brazil South | $0.50 |
| **Storage Account** | Standard LRS | Brazil South | $0.15 |

**Subtotal Recursos Estado: ~$0.65/mês**

## 📈 **CUSTO TOTAL ESTIMADO: ~$13.72/mês**

## 🔍 Detalhamento dos Custos

### VM Standard_B1s
- **vCPUs**: 1
- **RAM**: 1 GB
- **Armazenamento**: 30 GB Standard HDD
- **Ideal para**: Ambiente DEV/Testing
- **Custo**: $7.88/mês (~$0.0108/hora)

### Networking
- **Public IP Standard**: $3.65/mês (mais caro que Basic)
- **Ingress**: Gratuito
- **Egress**: Primeiros 100GB gratuitos

### Storage & Security
- **Key Vault**: $0.50/mês (Standard tier)
- **Storage Account**: $0.15/mês (LRS, <1GB)

## 💡 Otimizações de Custo Implementadas

### ✅ Já Otimizado
- **VM Size**: Standard_B1s (menor custo para Windows)
- **Disk**: Standard HDD (mais barato que SSD)
- **Storage**: LRS replication (menor custo)
- **Region**: East US (menor custo geral)

### ⚠️ Custos Elevados Identificados
- **Public IP Standard**: $3.65/mês (26% do custo total)
  - **Motivo**: Basic SKU não disponível na subscription
  - **Alternativa**: Usar Azure Bastion ($16/mês) - não compensa

## 📊 Comparativo de Regiões

| Região | VM B1s | Diferença |
|--------|--------|-----------|
| **East US** | $7.88 | Baseline |
| Brazil South | $9.89 | +25.5% |
| West Europe | $8.61 | +9.3% |

**✅ East US escolhido = Economia de $2.01/mês vs Brazil South**

## 🎯 Recomendações para Redução de Custos

### Imediatas
1. **Agendar VM**: Ligar apenas durante horário de trabalho
   - **Economia**: ~$5.25/mês (8h/dia, 22 dias úteis)
   
2. **Auto-Shutdown**: Configurar desligamento automático
   - **Portal**: VM > Operations > Auto-shutdown

### Futuras
1. **Spot Instances**: Para testes não críticos (-90%)
2. **Reserved Instances**: Para uso contínuo (-40%)
3. **Azure Hybrid Benefit**: Se tiver licenças Windows

## 📋 Monitoramento Recomendado

### Azure Cost Management
```bash
# Configurar alertas de custo
az consumption budget create \
  --budget-name "dev-vm-budget" \
  --amount 20 \
  --resource-group "rg-dev-sql-vm"
```

### Tags para Tracking
- **Environment**: DEV
- **Project**: ALEPROJ  
- **Owner**: DevOps Team
- **CostCenter**: Development

## 🚀 Próximos Passos

1. **Monitorar custos** primeiros 30 dias
2. **Implementar auto-shutdown** se apropriado
3. **Avaliar utilização** da VM
4. **Considerar spot instances** para testes

---

**💰 Custo Final: $13.72/mês**  
**🎯 Objetivo: <$15/mês ✅**

*Atualizado em: 01/10/2025*