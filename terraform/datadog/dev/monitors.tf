# ---------------------------------------------------------------------------
# Example monitors.
#
# Thresholds are intentionally variables so they can be tuned after observing
# real baseline traffic. Do not treat these defaults as production truth.
# ---------------------------------------------------------------------------

resource "datadog_monitor" "endpoint_failures" {
  name    = "[${var.environment}] ${var.service_name} - endpoint failures"
  type    = "metric alert"
  message = <<-EOT
    Endpoint failures are above the configured threshold.

    Investigate:
    1. APM traces for service:${var.service_name} env:${var.environment}
    2. Logs with @event_name:user.endpoint_access_failed
    3. Recent deployment events and application version

    This threshold is an example and should be tuned from baseline traffic.
  EOT

  query = "sum(last_5m):sum:app.user.endpoint.failure{*}.as_count() > ${var.endpoint_failure_threshold_5m}"

  monitor_thresholds {
    critical          = var.endpoint_failure_threshold_5m
    critical_recovery = max(var.endpoint_failure_threshold_5m - 2, 0)
  }

  include_tags        = true
  notify_no_data      = false
  require_full_window = false
  tags                = local.tags
}

resource "datadog_monitor" "server_errors" {
  name    = "[${var.environment}] ${var.service_name} - HTTP 5xx spike"
  type    = "metric alert"
  message = <<-EOT
    HTTP 5xx events are above the configured threshold.

    Search logs:
    service:${var.service_name} env:${var.environment} @http_status_code:[500 TO 599]
  EOT

  query = "sum(last_5m):sum:app.user.endpoint.failure{http_status_code:5*}.as_count() > ${var.server_error_threshold_5m}"

  monitor_thresholds {
    critical          = var.server_error_threshold_5m
    critical_recovery = max(var.server_error_threshold_5m - 1, 0)
  }

  include_tags        = true
  notify_no_data      = false
  require_full_window = false
  tags                = local.tags
}

resource "datadog_monitor" "login_failures" {
  name    = "[${var.environment}] ${var.service_name} - login failure spike"
  type    = "metric alert"
  message = "Login failures are above the configured 5-minute threshold. Review login.failed business events and correlated traces."

  query = "sum(last_5m):sum:app.login.failure{*}.as_count() > ${var.login_failure_threshold_5m}"

  monitor_thresholds {
    critical          = var.login_failure_threshold_5m
    critical_recovery = max(var.login_failure_threshold_5m - 2, 0)
  }

  include_tags        = true
  notify_no_data      = false
  require_full_window = false
  tags                = local.tags
}

resource "datadog_monitor" "endpoint_latency" {
  name    = "[${var.environment}] ${var.service_name} - endpoint p95 latency"
  type    = "metric alert"
  message = "Endpoint p95 latency is above the configured threshold. Inspect APM traces and downstream spans."

  query = "percentile(last_5m):p95:app.user.endpoint.duration{*} > ${var.latency_p95_ms_threshold}"

  monitor_thresholds {
    critical          = var.latency_p95_ms_threshold
    critical_recovery = var.latency_p95_ms_threshold * 0.8
  }

  include_tags        = true
  notify_no_data      = false
  require_full_window = false
  tags                = local.tags
}
