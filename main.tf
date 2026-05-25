

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-avm-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "snet-avm-vm"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

module "avm-res-compute-virtualmachine" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.20.0"

  location            = var.location
  name                = var.name
  resource_group_name = azurerm_resource_group.rg.name
  zone                = var.zone
  sku_size            = "Standard_D2s_v3"

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

