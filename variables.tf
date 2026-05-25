variable "location" {
  type        = string
  description = "Azure region for deployment."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where the VM will be deployed."
}

variable "name" {
  type        = string
  description = "Name of the virtual machine."
}

variable "zone" {
  type        = string
  description = "Availability zone for the VM (for example \"1\")."
}

variable "vnet_name" {
  type        = string
  description = "Name of the virtual network to create."
  default     = "vnet-avm-vm"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address space for the virtual network."
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet inside the virtual network."
  default     = "snet-avm-vm"
}

variable "subnet_prefixes" {
  type        = list(string)
  description = "Address prefixes for the subnet."
  default     = ["10.0.1.0/24"]
}

variable "sku_size" {
  type        = string
  description = "VM SKU/size for the Azure virtual machine."
  default     = "Standard_D2s_v3"
}

variable "admin_public_key_path" {
  type        = string
  description = "Path to SSH public key file for VM admin access. Prefer an absolute path."
  default     = "/Users/levent/.ssh/id_rsa.pub"
}

variable "vms" {
  type = map(any)
  description = "Map of VM definitions. Keys are identifiers; values must include 'name', 'sku_size', 'admin_username' and 'os_type'. Optional 'zone'."
  default = {
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
}

variable encryption_at_host_enabled {
  type        = bool
  description = "Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host?"
  default     = false
}
variable "password_authentication_disabled" {
  type        = bool
  description = "Whether to disable password authentication for the VM."
  default     = true
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "The resource ID of an existing Log Analytics workspace to send diagnostic logs to. Leave empty to disable."
  default     = ""
}
