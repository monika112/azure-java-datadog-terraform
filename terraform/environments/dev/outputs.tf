output "resource_group_name" {
  value       = module.resource_group.name
  description = "Application resource group."
}

output "vnet_name" {
  value = module.network.vnet_name
}

output "container_apps_subnet_id" {
  value = module.network.container_apps_subnet_id
}

output "log_analytics_workspace_name" {
  value = module.log_analytics.name
}

output "acr_name" {
  value = module.acr.name
}

output "acr_login_server" {
  value = module.acr.login_server
}

output "key_vault_name" {
  value = module.key_vault.name
}

output "managed_identity_id" {
  value = module.managed_identity.id
}

output "managed_identity_client_id" {
  value = module.managed_identity.client_id
}

output "container_app_environment_name" {
  value = module.container_app_environment.name
}

output "container_app_name" {
  value = module.container_app.name
}

output "container_app_fqdn" {
  description = "Stable Container App ingress FQDN."
  value       = module.container_app.fqdn
}

output "latest_revision_fqdn" {
  description = "Latest revision-specific FQDN."
  value       = module.container_app.latest_revision_fqdn
}
