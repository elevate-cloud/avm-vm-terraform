terraform {
  backend "azurerm" {
    resource_group_name  = "rg-avm-tfstate"
    storage_account_name = "strtfstate0981237645"
    container_name       = "tfstate"
    key                  = "avm-terraform.tfstate"
    # access_key         = "<optional-access-key>" # do NOT commit secrets to VCS
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
