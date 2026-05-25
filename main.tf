

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_prefixes
}

module "avm-res-compute-virtualmachine" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.20.0"

  location            = var.location
  name                = var.name
  resource_group_name = azurerm_resource_group.rg.name
  zone                = var.zone
  sku_size            = var.sku_size

  encryption_at_host_enabled = false

  network_interfaces = {
    nic1 = {
      name = "avmvm-nic1"
      ip_configurations = {
        ipconfig1 = {
          name                          = "ipconfig1"
          private_ip_subnet_resource_id = azurerm_subnet.subnet.id
          create_public_ip_address      = true
          public_ip_address_name        = "avmvm01-pip"
        }
      }
    }
  }
}

