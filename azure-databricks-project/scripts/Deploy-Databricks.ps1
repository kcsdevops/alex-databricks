# Script to deploy Azure Databricks with cost optimization
# Deploy-Databricks.ps1

param(
    [Parameter(Mandatory=$false)]
    [string]$Action = "plan",
    
    [Parameter(Mandatory=$false)]
    [switch]$AutoApprove,
    
    [Parameter(Mandatory=$false)]
    [switch]$LoadCredentials = $true
)

Write-Host "🚀 Azure Databricks Deployment Script" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

# Change to terraform directory
Set-Location -Path "terraform"

try {
    # Load credentials if requested
    if ($LoadCredentials) {
        Write-Host "🔑 Loading Azure credentials from Key Vault..." -ForegroundColor Yellow
        $scriptPath = Join-Path $PSScriptRoot "load-credentials.ps1"
        if (Test-Path $scriptPath) {
            & $scriptPath
        } else {
            Write-Warning "Credentials script not found. Make sure you're authenticated to Azure."
        }
    }

    # Initialize Terraform
    Write-Host "🔧 Initializing Terraform..." -ForegroundColor Yellow
    terraform init -upgrade

    if ($LASTEXITCODE -ne 0) {
        throw "Terraform initialization failed"
    }

    # Validate configuration
    Write-Host "✅ Validating Terraform configuration..." -ForegroundColor Yellow
    terraform validate

    if ($LASTEXITCODE -ne 0) {
        throw "Terraform validation failed"
    }

    # Execute requested action
    switch ($Action.ToLower()) {
        "plan" {
            Write-Host "📋 Creating Terraform plan..." -ForegroundColor Yellow
            terraform plan -var-file="terraform.tfvars" -out="databricks.tfplan"
        }
        "apply" {
            Write-Host "🚀 Applying Terraform configuration..." -ForegroundColor Yellow
            if ($AutoApprove) {
                terraform apply -var-file="terraform.tfvars" -auto-approve
            } else {
                terraform apply -var-file="terraform.tfvars"
            }
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Deployment completed successfully!" -ForegroundColor Green
                Write-Host ""
                Write-Host "🎯 Next steps:" -ForegroundColor Cyan
                Write-Host "1. Access your Databricks workspace via the URL provided in outputs"
                Write-Host "2. Configure your development environment"
                Write-Host "3. Import sample notebooks"
                Write-Host "4. Set up monitoring and alerts"
                
                # Display outputs
                Write-Host ""
                Write-Host "📊 Deployment Information:" -ForegroundColor Cyan
                terraform output
            }
        }
        "destroy" {
            Write-Host "💥 Destroying infrastructure..." -ForegroundColor Red
            Write-Host "⚠️  This will delete all Databricks resources!" -ForegroundColor Yellow
            
            $confirm = Read-Host "Are you sure you want to destroy the infrastructure? (yes/no)"
            if ($confirm -eq "yes") {
                terraform destroy -var-file="terraform.tfvars" -auto-approve
            } else {
                Write-Host "Destruction cancelled." -ForegroundColor Yellow
            }
        }
        "output" {
            Write-Host "📊 Displaying Terraform outputs..." -ForegroundColor Yellow
            terraform output
        }
        default {
            Write-Host "❌ Invalid action. Use: plan, apply, destroy, or output" -ForegroundColor Red
            exit 1
        }
    }

    # Cost reminder
    if ($Action -eq "apply" -and $LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "💰 Cost Optimization Reminder:" -ForegroundColor Yellow
        Write-Host "• Clusters will auto-terminate after 20 minutes of inactivity"
        Write-Host "• Spot instances are enabled for cost savings"
        Write-Host "• Monitor usage via Azure Cost Management"
        Write-Host "• Estimated cost: ~R$ 71.23/month with optimizations"
    }

} catch {
    Write-Host "❌ Error during deployment: $_" -ForegroundColor Red
    exit 1
} finally {
    # Return to original directory
    Set-Location -Path ".."
}