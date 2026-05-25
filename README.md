Terraform Azure Deploy — GitHub Actions

This repository uses Terraform to provision Azure resources. A GitHub Actions workflow (./.github/workflows/terraform-azure.yml) runs terraform init/plan/apply and supports an Azure Storage backend.

Prerequisites
- Azure CLI installed and logged in locally: az login
- gh (GitHub CLI) installed and authenticated: gh auth login
- Subscription ID and repository admin permissions to add GitHub Secrets.

1) Create an Azure Service Principal (for AZURE_CREDENTIALS)

Replace <SUBSCRIPTION_ID> and run locally:

  AZURE_CREDENTIALS=$(az ad sp create-for-rbac --name "gh-actions-terraform" --role "Contributor" --sdk-auth --scopes /subscriptions/<SUBSCRIPTION_ID>)
  echo "$AZURE_CREDENTIALS" | gh secret set AZURE_CREDENTIALS

This stores the JSON needed by azure/login@v1.

2) (Optional) Create backend storage resources (or let the workflow create them)

Replace placeholders and run locally if you prefer to create resources yourself:

  RG="tfstate-rg"
  SA="tfstate$(date +%s | sha256sum | cut -c1-8)"  # must be globally unique and lowercase
  CONTAINER="tfstate"
  LOCATION="eastus"

  az group create --name "$RG" --location "$LOCATION"
  az storage account create --name "$SA" --resource-group "$RG" --sku Standard_LRS --location "$LOCATION"
  az storage container create --name "$CONTAINER" --account-name "$SA"

  # Get storage key (optional if using AZURE_CREDENTIALS auth)
  STORAGE_KEY=$(az storage account keys list --resource-group "$RG" --account-name "$SA" --query "[0].value" -o tsv)

3) Set required GitHub Secrets (examples using gh CLI)

# Backend and workflow configuration
  echo "$RG" | gh secret set TF_BACKEND_RESOURCE_GROUP
  echo "$SA" | gh secret set TF_BACKEND_STORAGE_ACCOUNT
  echo "$CONTAINER" | gh secret set TF_BACKEND_CONTAINER
  echo "avm-terraform.tfstate" | gh secret set TF_BACKEND_KEY
  # If you created the storage account and need to provide the access key:
  echo "$STORAGE_KEY" | gh secret set TF_BACKEND_STORAGE_KEY
  # If you want the workflow to create the backend resources for you:
  echo "true" | gh secret set TF_BACKEND_CREATE
  echo "$LOCATION" | gh secret set AZURE_LOCATION

# Optional: provide terraform variables via a single secret
  # Create a terraform.tfvars file locally and then:
  cat terraform.tfvars | gh secret set TERRAFORM_VARS

4) Workflow behavior summary
- The workflow logs into Azure using AZURE_CREDENTIALS.
- If TF_BACKEND_CREATE=true the workflow attempts to create the resource group, storage account and container before init.
- The workflow runs terraform init with backend-config values from the TF_BACKEND_* secrets.
- The workflow runs terraform plan and then terraform apply only on main branch.

5) Example terraform.tfvars

location = "eastus"
resource_group_name = "rg-avm"
vnet_name = "avm-vnet"
vnet_address_space = ["10.0.0.0/16"]
subnet_name = "avm-subnet"
subnet_prefixes = ["10.0.1.0/24"]
sku_size = "Standard_B1s"

# Example vms map (simplified)
vms = {
  vm1 = {
    name = "avm-vm1"
    sku_size = "Standard_B1s"
    admin_username = "azureuser"
    os_type = "Linux"
  }
}

6) Security recommendations
- Grant least privilege to the service principal (narrow scope if possible).
- Rotate and revoke credentials as needed.
- Prefer managed identities and short-lived credentials where possible.

Triggering
- Push to main or use Actions -> workflow_dispatch to run the workflow.

If you'd like, I can also add a GitHub Actions job to validate terraform fmt and terraform validate before planning. Say "yes" to add it.

IMPORTANT: backend moved to terraform.tf
terraform.tf now contains an azurerm backend block with placeholder values. Replace the REPLACE_WITH_* placeholders with your resource group, storage account and container names, or manage backend configuration via CI secrets. Do NOT commit storage account access keys or other secrets into source control.
