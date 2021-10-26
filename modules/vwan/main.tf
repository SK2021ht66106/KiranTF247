resource "azurerm_virtual_wan" "main" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  allow_branch_to_branch_traffic = var.allow_branch_to_branch_traffic
}

resource "azurerm_virtual_hub" "main" {
  for_each            = { for hub in var.hubs : hub.region => hub }
  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  virtual_wan_id      = azurerm_virtual_wan.main.id
  address_prefix      = each.value.prefix
}


resource "azurerm_virtual_hub_connection" "main" {
  for_each                  = { for c in var.connections : c.region => c }
  name                      = basename(each.key)
  virtual_hub_id            = azurerm_virtual_hub.main[each.value.region].id
  remote_virtual_network_id = each.value.id
}