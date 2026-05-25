Terraform Azure Deploy — GitHub Actions

This repository uses Terraform to provision Azure resources. A GitHub Actions workflow (./github/workflows/terraform-azure.yml) runs terraform init/plan/apply and supports an Azure Storage backend.

Prerequisites
- Azure CLI installed and logged in locally (az login).
- A subscription ID and repository admin to add GitHub Secrets.

Create an Azure Service Principal (for AZURE_CREDENTIALS)
Run locally:

  az ad sp create-for-rbac --name "gh-actions-terraform" --role "Contributor" --sdk-auth --scopes /subscriptions/<SUBSCRIPTION_ID>

Copy the JSON output and save it as the GitHub Secret AZURE_CREDENTIALS.

Backend storage (optional — workflow can create it if TF_BACKEND_CREATE=true)

Create resource group, storage account and container:

  az group create --name <rg-name> --location <location>
  az storage account create --name <storageacctname> --resource-group <rg-name> --sku Standard_LRS
  az storage container create --name <container-name> --account-name <storageacctname>

Get the storage key (optional if using AZURE_CREDENTIALS authentication):

  az storage account keys list --resource-group <rg-name> --account-name <storageacctname> --query "[0].value" -o tsv

Required GitHub Secrets
- AZURE_CREDENTIALS — service principal JSON (from az ad sp create-for-rbac --sdk-auth)
- TF_BACKEND_RESOURCE_GROUP — resource group for storage account
- TF_BACKEND_STORAGE_ACCOUNT — storage account name
- TF_BACKEND_CONTAINER — blob container name
- TF_BACKEND_KEY — state filename (e.g. avm-terraform.tfstate)
- TF_BACKEND_STORAGE_KEY — storage account key (optional)
- TF_BACKEND_CREATE — "true" if workflow should create backend resources
- AZURE_LOCATION — region used when creating backend resources
- TERRAFORM_VARS — (optional) contents of terraform.tfvars

Example terraform.tfvars

location = "eastus"
resource_group_name = "rg-avm"
vnet_name = "avm-vnet"
vnet_address_space = ["10.0.0.0/16"]
subnet_name = "avm-subnet"
subnet_prefixes = ["10.0.1.0/24"]

Triggering
- Push to main or use Actions -> workflow_dispatch to run the workflow.

Security
- Grant the least privilege required and rotate credentials regularly.

If you want, the README can include exact example values and a step-by-step on how to set each secret; say "yes" and that will be added.
