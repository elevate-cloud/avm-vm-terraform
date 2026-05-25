terraform {
  backend "azurerm" {
    resource_group_name  = "REPLACE_WITH_RG"
    storage_account_name = "REPLACE_WITH_STORAGE_ACCOUNT"
    container_name       = "REPLACE_WITH_CONTAINER"
    key                  = "avm-terraform.tfstate"
    # access_key         = "REPLACE_WITH_STORAGE_KEY" # optional, not recommended in VCS
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "azurerm" {
  features {}
}
