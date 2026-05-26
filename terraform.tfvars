location            = "centralus"
resource_group_name = "rg-avm-vm-new"
name                = "avmvm01"
zone                = "1"
vnet_name           = "vnet-avm-vm"
vnet_address_space  = ["10.0.0.0/16"]
subnet_name         = "snet-avm-vm"
subnet_prefixes     = ["10.0.1.0/24"]
sku_size            = "Standard_D2s_v3"
admin_public_key_path = "/Users/levent/.ssh/id_rsa.pub"
nsg_name            = "nsg-avm"
encryption_at_host_enabled = false
password_authentication_disabled = true
log_analytics_workspace_id = ""
law_name = "law-avm"

vms = {
  linux = {
    name = "avm-linux"
    sku_size = "Standard_D2s_v3"
    admin_username = "azureuser"
    os_type = "Linux"
    password_authentication_disabled = false
    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts-gen2"
      version   = "latest"
    }
  }
  windows = {
    name = "avm-windows"
    sku_size = "Standard_D2s_v3"
    admin_username = "azureuser"
    os_type = "Windows"
    password_authentication_disabled = true
    source_image_reference = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2022-datacenter-g2"
      version   = "latest"
    }
  }
}
