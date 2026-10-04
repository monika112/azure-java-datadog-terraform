resource "azurerm_container_app" "this" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.container_app_environment_id
  revision_mode                = var.revision_mode
  tags                         = var.tags

  identity {
    type = "UserAssigned"
    identity_ids = [
      var.managed_identity_id
    ]
  }

  secret {
    name                = "datadog-api-key"
    identity            = var.managed_identity_id
    key_vault_secret_id = var.datadog_api_key_secret_id
  }

  registry {
    server   = var.acr_login_server
    identity = var.managed_identity_id
  }

  ingress {
    external_enabled = var.external_ingress
    target_port      = var.target_port
    transport        = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = "app"
      image  = var.image
      cpu    = 0.5
      memory = "1Gi"


      env {
        name        = "DD_API_KEY"
        secret_name = "datadog-api-key"
      }

      dynamic "env" {
        for_each = var.environment_variables
        content {
          name  = env.key
          value = env.value
        }
      }


      dynamic "liveness_probe" {
        for_each = var.enable_application_probes ? [1] : []
        content {
          transport               = "HTTP"
          port                    = var.target_port
          path                    = var.liveness_path
          initial_delay           = 15
          interval_seconds        = 20
          timeout                 = 5
          failure_count_threshold = 3
        }
      }

      dynamic "readiness_probe" {
        for_each = var.enable_application_probes ? [1] : []
        content {
          transport               = "HTTP"
          port                    = var.target_port
          path                    = var.readiness_path
          initial_delay           = 10
          interval_seconds        = 10
          timeout                 = 5
          failure_count_threshold = 3
          success_count_threshold = 1
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      # CI/CD will own application image/revision rollout after Phase 4.
      template[0].container[0].image
    ]
  }
}
