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
