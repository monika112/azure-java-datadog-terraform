locals {
  tags = [
    "service:${var.service_name}",
    "env:${var.environment}",
    "team:${var.team}",
    "managed_by:terraform"
  ]

  log_filter = "service:${var.service_name} env:${var.environment}"
}
