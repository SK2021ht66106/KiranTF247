output "name_servers" {
  value = azurerm_dns_zone.main.*.name_servers
}

output "DNS_Zone_Name" {
  value = azurerm_dns_zone.main[0].name
}




output "private_dns_zone_name" {
  value = azurerm_private_dns_zone.main.0.name

  depends_on = [azurerm_private_dns_zone.main]
}
