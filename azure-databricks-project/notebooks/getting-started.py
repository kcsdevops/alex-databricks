# Databricks notebook source
# MAGIC %md
# MAGIC # 🚀 Getting Started with Azure Databricks
# MAGIC 
# MAGIC **Bem-vindo ao seu ambiente de desenvolvimento Databricks!**
# MAGIC 
# MAGIC Este notebook serve como introdução ao seu novo ambiente Analytics otimizado para custos.
# MAGIC 
# MAGIC ## 📋 Informações do Ambiente
# MAGIC 
# MAGIC - **Cluster**: Auto-terminação em 20 minutos
# MAGIC - **Instâncias**: Spot instances para economia de até 80%
# MAGIC - **Auto-scaling**: 1-2 workers conforme demanda
# MAGIC - **Custo estimado**: ~R$ 71.23/mês
# MAGIC 
# MAGIC ## 🎯 Próximos Passos
# MAGIC 
# MAGIC 1. ✅ Execute este notebook para verificar a configuração
# MAGIC 2. 📊 Explore os notebooks de análise de dados
# MAGIC 3. 🤖 Teste os exemplos de Machine Learning
# MAGIC 4. 📈 Configure monitoramento de custos

# COMMAND ----------

# MAGIC %md
# MAGIC ## 🔧 Verificação do Ambiente
# MAGIC 
# MAGIC Vamos verificar se tudo está funcionando corretamente:

# COMMAND ----------

# Verificar versão do Spark
print(f"🔥 Spark Version: {spark.version}")
print(f"🐍 Python Version: {sys.version}")

# Verificar configuração do cluster
print(f"🖥️  Cluster Name: {spark.conf.get('spark.databricks.clusterUsageTags.clusterName')}")
print(f"⚡ Driver Node Type: {spark.conf.get('spark.databricks.clusterUsageTags.clusterNodeType')}")

# COMMAND ----------

# MAGIC %md
# MAGIC ## 📊 Teste de Funcionalidade Básica
# MAGIC 
# MAGIC Vamos criar um DataFrame simples para testar as funcionalidades:

# COMMAND ----------

import sys
from datetime import datetime
from pyspark.sql import functions as F
from pyspark.sql.types import *

# Criar dados de exemplo
data = [
    ("Azure", "Databricks", 100, "2025-01-01"),
    ("Machine", "Learning", 200, "2025-01-02"),
    ("Data", "Analytics", 150, "2025-01-03"),
    ("Cost", "Optimization", 80, "2025-01-04"),
    ("Spot", "Instances", 60, "2025-01-05")
]

schema = StructType([
    StructField("category", StringType(), True),
    StructField("subcategory", StringType(), True),
    StructField("value", IntegerType(), True),
    StructField("date", StringType(), True)
])

# Criar DataFrame
df = spark.createDataFrame(data, schema)

# Mostrar dados
print("📋 Dados de Exemplo:")
df.show()

# COMMAND ----------

# MAGIC %md
# MAGIC ## 📈 Análise Básica dos Dados

# COMMAND ----------

# Estatísticas descritivas
print("📊 Estatísticas Descritivas:")
df.describe().show()

# Agregações simples
print("🔢 Soma total por categoria:")
df.groupBy("category").agg(F.sum("value").alias("total_value")).orderBy(F.desc("total_value")).show()

# Criar visualização simples
display(df.groupBy("category").agg(F.sum("value").alias("total_value")).orderBy(F.desc("total_value")))

# COMMAND ----------

# MAGIC %md
# MAGIC ## 💰 Informações de Custo e Otimização

# COMMAND ----------

# Informações sobre otimização de custos
cost_info = {
    "cluster_config": {
        "auto_termination": "20 minutos",
        "instance_type": "Standard_DS3_v2",  
        "spot_instances": "Habilitado",
        "auto_scaling": "1-2 workers"
    },
    "estimated_costs": {
        "monthly_usd": 13.39,
        "monthly_brl": 71.23,
        "savings_with_optimization": "75-88%"
    },
    "cost_controls": [
        "Auto-terminação de cluster",
        "Uso de Spot Instances",
        "Auto-scaling responsivo",
        "Monitoramento via Azure Cost Management"
    ]
}

print("💰 Configuração de Otimização de Custos:")
print("=" * 50)
for key, value in cost_info.items():
    print(f"\n{key.upper()}:")
    if isinstance(value, dict):
        for k, v in value.items():
            print(f"  • {k}: {v}")
    elif isinstance(value, list):
        for item in value:
            print(f"  • {item}")
    else:
        print(f"  {value}")

# COMMAND ----------

# MAGIC %md
# MAGIC ## 🔍 Verificação de Recursos Disponíveis

# COMMAND ----------

# Verificar libraries disponíveis
print("📚 Bibliotecas de Data Science Disponíveis:")
libraries_to_check = [
    "pandas", "numpy", "matplotlib", "seaborn", 
    "scikit-learn", "mlflow", "koalas", "plotly"
]

available_libraries = []
for lib in libraries_to_check:
    try:
        __import__(lib)
        available_libraries.append(f"✅ {lib}")
    except ImportError:
        available_libraries.append(f"❌ {lib}")

for lib_status in available_libraries:
    print(lib_status)

# COMMAND ----------

# MAGIC %md
# MAGIC ## 🎯 Próximos Notebooks Recomendados
# MAGIC 
# MAGIC 1. **📊 Data Analysis Sample** - Análise exploratória de dados
# MAGIC 2. **🤖 ML Pipeline Example** - Pipeline completo de Machine Learning  
# MAGIC 3. **💾 Data Lake Integration** - Integração com Azure Data Lake
# MAGIC 4. **📈 Visualization Examples** - Exemplos de visualização avançada
# MAGIC 
# MAGIC ## 💡 Dicas de Otimização
# MAGIC 
# MAGIC - 🕐 **Auto-terminação**: Cluster para automaticamente após 20 min
# MAGIC - 💰 **Spot Instances**: Economia de até 80% nos custos de compute
# MAGIC - 📊 **Monitoring**: Acompanhe custos via Azure Cost Management
# MAGIC - 🔄 **Auto-scaling**: Recursos ajustam conforme demanda
# MAGIC 
# MAGIC ---
# MAGIC 
# MAGIC **✅ Configuração verificada com sucesso!**
# MAGIC 
# MAGIC Seu ambiente Databricks está pronto para desenvolvimento com otimização de custos habilitada.