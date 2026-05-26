

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

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = var.law_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 60
}



module "avm_vm" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.20.0"
  for_each = var.vms

  location            = var.location
  name                = each.value.name
  resource_group_name = azurerm_resource_group.rg.name
  zone                = lookup(each.value, "zone", var.zone)
  sku_size            = lookup(each.value, "sku_size", var.sku_size)

  os_type = lookup(each.value, "os_type", "Linux")

  account_credentials = {
    admin_credentials = {
      username                           = lookup(each.value, "admin_username", "azureuser")
      ssh_keys                           = []
      generate_admin_password_or_ssh_key = true
    }
    password_authentication_disabled = lookup(each.value, "password_authentication_disabled", true)
  }

  # Ensure Encryption at Host is disabled for this subscription
  encryption_at_host_enabled = var.encryption_at_host_enabled

  # Image selection per-VM
  source_image_reference = lookup(each.value, "source_image_reference", null)

  network_interfaces = {
    nic1 = {
      name = "${each.value.name}-nic1"
      ip_configurations = {
        ipconfig1 = {
          name                          = "ipconfig1"
          private_ip_subnet_resource_id = azurerm_subnet.subnet.id
          create_public_ip_address      = false
        }
      }
      network_security_groups = {
        nsg1 = {
          network_security_group_resource_id = azurerm_network_security_group.nsg.id
        }
      }
      diagnostic_settings = {
        ds1 = {
          name                  = "${each.value.name}-diag"
          workspace_resource_id = azurerm_log_analytics_workspace.law.id
          metric_categories     = ["AllMetrics"]
        }
      }
    }
  }
}

