resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
  numeric = true
}

locals {
  common_tags = merge(
    var.tags,
    {
      environment = var.environment
      service     = var.service_name
    }
  )

  # ACR names must be globally unique and contain only alphanumeric characters.
  acr_name = substr(
    lower(replace("acr${var.app_name}${var.environment}${random_string.suffix.result}", "-", "")),
    0,
    50
  )

  # Key Vault names are globally unique and limited to 24 characters.
  key_vault_name = substr(
    lower("kv-${var.app_name}-${var.environment}-${random_string.suffix.result}"),
    0,
    24
  )
}

module "resource_group" {
  source = "../../modules/resource-group"

  name     = "rg-${var.app_name}-${var.environment}"
  location = var.location
  tags     = local.common_tags
}

module "network" {
  source = "../../modules/network"

  name                        = "vnet-${var.app_name}-${var.environment}"
  resource_group_name         = module.resource_group.name
  location                    = module.resource_group.location
  address_space               = var.vnet_address_space
  container_apps_subnet_name  = "snet-aca-${var.environment}"
  container_apps_subnet_cidrs = var.aca_subnet_address_prefixes
  tags                        = local.common_tags
}

module "log_analytics" {
  source = "../../modules/log-analytics"

  name                = "log-${var.app_name}-${var.environment}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  retention_in_days   = 30
  tags                = local.common_tags
}

module "acr" {
  source = "../../modules/acr"

  name                = local.acr_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = local.common_tags
}

module "managed_identity" {
  source = "../../modules/managed-identity"

  name                = "id-${var.app_name}-${var.environment}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  tags                = local.common_tags
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.managed_identity.principal_id
}

module "key_vault" {
  source = "../../modules/key-vault"

  name                = local.key_vault_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  enable_rbac         = true
  tags                = local.common_tags
}

resource "azurerm_role_assignment" "application_key_vault_secrets_user" {
  scope                = module.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.managed_identity.principal_id
}

module "container_app_environment" {
  source = "../../modules/container-app-environment"

  name                       = "cae-${var.app_name}-${var.environment}"
  resource_group_name        = module.resource_group.name
  location                   = module.resource_group.location
  log_analytics_workspace_id = module.log_analytics.id
  infrastructure_subnet_id   = module.network.container_apps_subnet_id
  tags                       = local.common_tags
}

data "azurerm_client_config" "current" {}

module "container_app" {
  source = "../../modules/container-app"

  name                         = "ca-${var.app_name}-${var.environment}"
  resource_group_name          = module.resource_group.name
  container_app_environment_id = module.container_app_environment.id

  image            = var.bootstrap_image
  target_port      = var.container_port
  min_replicas     = var.min_replicas
  max_replicas     = var.max_replicas
  revision_mode    = "Multiple"
  external_ingress = true

  managed_identity_id       = module.managed_identity.id
  acr_login_server          = module.acr.login_server
  datadog_api_key_secret_id = "${module.key_vault.vault_uri}secrets/datadog-api-key"

  environment_variables = {
    DD_SITE                  = "datadoghq.com"
    DD_LOGS_ENABLED          = "true"
    DD_LOGS_INJECTION        = "true"
    DD_SOURCE                = "java"
    DD_ENV                   = var.environment
    DD_SERVICE               = var.service_name
    DD_VERSION               = "v3"
    JAVA_TOOL_OPTIONS        = "-javaagent:/app/dd-java-agent.jar"
    DD_AZURE_SUBSCRIPTION_ID = data.azurerm_client_config.current.subscription_id
    DD_AZURE_RESOURCE_GROUP  = module.resource_group.name
  }

  liveness_path  = "/api/health/live"
  readiness_path = "/api/health/ready"

  # The bootstrap image does not expose our Spring endpoints.
  # Probes stay disabled during the infrastructure bootstrap.
  # Turn this on when Phase 4/CI deploys the Java image.
  enable_application_probes = false

  tags = local.common_tags

  depends_on = [
    azurerm_role_assignment.acr_pull
  ]
}
