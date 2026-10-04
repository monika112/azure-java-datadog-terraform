output "id" { value = azurerm_container_app.this.id }
output "name" { value = azurerm_container_app.this.name }
output "latest_revision_name" { value = azurerm_container_app.this.latest_revision_name }
output "latest_revision_fqdn" { value = azurerm_container_app.this.latest_revision_fqdn }

output "fqdn" {
  description = "Stable Container App ingress FQDN."
  value       = try(azurerm_container_app.this.ingress[0].fqdn, null)
}
