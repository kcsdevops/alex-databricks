# Script to load Azure credentials from Key Vault for Databricks deployment
# load-credentials.ps1

Write-Host "🔑 Loading Azure Credentials from Key Vault" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green

try {
    # Check if Azure CLI is installed and user is logged in
    $azAccount = az account show 2>$null
    if (-not $azAccount) {
        Write-Host "🔐 Azure CLI login required..." -ForegroundColor Yellow
        az login
        
        if ($LASTEXITCODE -ne 0) {
            throw "Azure CLI login failed"
        }
    }

    # Set subscription (using the same from VM project)
    Write-Host "🎯 Setting Azure subscription..." -ForegroundColor Yellow
    az account set --subscription "your-subscription-id"  # Update with actual subscription ID

    # Key Vault details
    $keyVaultName = "kv-dev-terraform-667"
    $resourceGroup = "rg-dev-sql-vm"

    Write-Host "🗝️  Retrieving secrets from Key Vault: $keyVaultName" -ForegroundColor Yellow

    # Get Service Principal credentials
    $clientId = az keyvault secret show --vault-name $keyVaultName --name "terraform-sp-client-id" --query "value" -o tsv
    $clientSecret = az keyvault secret show --vault-name $keyVaultName --name "terraform-sp-secret" --query "value" -o tsv
    $tenantId = az keyvault secret show --vault-name $keyVaultName --name "terraform-sp-tenant-id" --query "value" -o tsv
    $subscriptionId = az account show --query "id" -o tsv

    if (-not $clientId -or -not $clientSecret -or -not $tenantId) {
        throw "Failed to retrieve Service Principal credentials from Key Vault"
    }

    # Set environment variables for Terraform
    Write-Host "🌍 Setting Terraform environment variables..." -ForegroundColor Yellow
    
    $env:ARM_CLIENT_ID = $clientId
    $env:ARM_CLIENT_SECRET = $clientSecret
    $env:ARM_TENANT_ID = $tenantId
    $env:ARM_SUBSCRIPTION_ID = $subscriptionId

    # Set Databricks environment variables
    $env:DATABRICKS_AZURE_CLIENT_ID = $clientId
    $env:DATABRICKS_AZURE_CLIENT_SECRET = $clientSecret
    $env:DATABRICKS_AZURE_TENANT_ID = $tenantId
    $env:DATABRICKS_AZURE_SUBSCRIPTION_ID = $subscriptionId

    Write-Host "✅ Credentials loaded successfully!" -ForegroundColor Green
    Write-Host "🎯 Client ID: $($clientId.Substring(0,8))..." -ForegroundColor Gray
    Write-Host "🎯 Tenant ID: $($tenantId.Substring(0,8))..." -ForegroundColor Gray
    Write-Host "🎯 Subscription ID: $($subscriptionId.Substring(0,8))..." -ForegroundColor Gray

    # Verify Service Principal has access
    Write-Host "🔍 Verifying Service Principal access..." -ForegroundColor Yellow
    az login --service-principal -u $clientId -p $clientSecret --tenant $tenantId --output none

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Service Principal authentication successful!" -ForegroundColor Green
    } else {
        throw "Service Principal authentication failed"
    }

    # Return to original user context
    az login --output none

} catch {
    Write-Host "❌ Error loading credentials: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "🔧 Troubleshooting steps:" -ForegroundColor Yellow
    Write-Host "1. Ensure you're logged in: az login"
    Write-Host "2. Check Key Vault access permissions"
    Write-Host "3. Verify Service Principal exists and has correct permissions"
    Write-Host "4. Ensure Key Vault contains required secrets:"
    Write-Host "   - terraform-sp-client-id"
    Write-Host "   - terraform-sp-secret"
    Write-Host "   - terraform-sp-tenant-id"
    exit 1
}