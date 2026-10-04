resource "datadog_service_level_objective" "api_availability" {
  name        = "[${var.environment}] ${var.service_name} API availability"
  type        = "metric"
  description = "Availability based on successful endpoint requests divided by total successful + failed endpoint requests."

  query {
    numerator = "sum:app.user.endpoint.success{*}.as_count()"
    denominator = "sum:app.user.endpoint.success{*}.as_count() + sum:app.user.endpoint.failure{*}.as_count()"
  }

  thresholds {
    timeframe = "7d"
    target    = var.availability_slo_target
    warning   = min(var.availability_slo_target + 0.05, 99.99)
  }

  thresholds {
    timeframe = "30d"
    target    = var.availability_slo_target
    warning   = min(var.availability_slo_target + 0.05, 99.99)
  }

  timeframe         = "30d"
  target_threshold  = var.availability_slo_target
  warning_threshold = min(var.availability_slo_target + 0.05, 99.99)

  tags = local.tags
}
