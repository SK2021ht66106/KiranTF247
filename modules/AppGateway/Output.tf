
output "id" {
  description = "Id of the application gateway."
  value       = azurerm_application_gateway.main.id
}

output "name" {
  description = "Name of the application gateway."
  value       = azurerm_application_gateway.main.name
}
