resource "random_id" "main" {
  byte_length = "8"
}

resource "azurerm_dns_zone" "main" {
  count               = length(var.dns_zone_names)
  name                = (var.dns_zone_names)[count.index]
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone" "main" {
  count               = var.private_dns_zone_name == null ? 0 : 1
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_vnet_link" {
  count                 = length(var.private_dns_zone_vnet_links)
  name                  = "vnet-link-${random_id.main.hex}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.main.0.name
  registration_enabled  = var.private_registration_enabled
  virtual_network_id    = var.private_dns_zone_vnet_links[count.index]
  tags = var.tags
}