variable "name" {
  type        = string
  description = "The name of the Virtual WAN."
}

variable "resource_group_name" {
    type        = string
    description = "The resource group name in which to create the resources."
}

variable "resource_group_location" {
    type        = string
    description = "The resource group location in which to create the resources."
}

variable "allow_branch_to_branch_traffic" {
  type        = bool
  default     = true
  description = "Whether branch to branch traffic is allowed."
}

variable "allow_vnet_to_vnet_traffic" {
  type        = bool
  default     = false
  description = "Whether VNet to VNet traffic is allowed."
}

variable "hubs" {
  type = list(object({
    region = string
    prefix = string
  }))

  description = "A list of hubs to create within the virtual WAN."
}

variable "connections" {
  type = list(object({
    region = string
    id     = string
  }))

  description = "A mapping from each region to a list of virtual network IDs to which the virtual hub should be connected."
}
