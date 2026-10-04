# Datadog account resources intentionally begin as a separate root.
# This allows:
#
#   terraform/environments/dev
#
# to plan/apply Azure infrastructure without requiring DD_API_KEY/DD_APP_KEY.
#
# In the next Datadog phase this root will create:
# - dashboards
# - monitors
# - log-based metrics
# - SLOs
# - deployment/event integrations
#
# Set credentials through environment variables, never .tfvars:
#
#   DD_API_KEY
#   DD_APP_KEY
#
locals {
  service = var.service_name
  env     = var.environment
}
