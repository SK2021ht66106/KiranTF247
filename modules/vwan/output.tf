
output "vwan_id" {
  value       = azurerm_virtual_wan.main.id
  description = "Echoes back the `name` input variable value, for convenience if passing the result of this module elsewhere as an object."
}

output "hubs" {
  value = [
    for h in azurerm_virtual_hub.main : {
      region = h.location
      prefix = h.address_prefix
    }
  ]
  description = "A list of hubs within the virtual WAN."
}

output "connections" {
  value       = var.connections
  description = "Echoes back the `connections` input variable value, for convenience if passing the result of this module elsewhere as an object."

 
}