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
