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
}

variable "nsg_name" {
  type        = string
  description = "Name for the network security group."
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address space for the virtual network."
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet inside the virtual network."
}

variable "subnet_prefixes" {
  type        = list(string)
  description = "Address prefixes for the subnet."
}

variable "sku_size" {
  type        = string
  description = "VM SKU/size for the Azure virtual machine."
}

variable "admin_public_key_path" {
  type        = string
  description = "Path to SSH public key file for VM admin access. Prefer an absolute path."
}

variable "vms" {
  type = map(any)
  description = "Map of VM definitions. Keys are identifiers; values must include 'name', 'sku_size', 'admin_username' and 'os_type'. Optional 'zone'."
}

variable "encryption_at_host_enabled" {
  type        = bool
  description = "Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host?"
}

variable "password_authentication_disabled" {
  type        = bool
  description = "Whether to disable password authentication for the VM."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "The resource ID of an existing Log Analytics workspace to send diagnostic logs to. Leave empty to disable."
}
 variable "law_name" {
  type        = string
  description = "The name of an existing Log Analytics workspace to send diagnostic logs to. Leave empty to disable."
 }