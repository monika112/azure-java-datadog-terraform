output "dashboard_id" {
  value = datadog_dashboard_json.application.id
}

output "availability_slo_id" {
  value = datadog_service_level_objective.api_availability.id
}

output "monitor_ids" {
  value = {
    endpoint_failures = datadog_monitor.endpoint_failures.id
    server_errors     = datadog_monitor.server_errors.id
    login_failures    = datadog_monitor.login_failures.id
    endpoint_latency  = datadog_monitor.endpoint_latency.id
  }
}

output "log_metric_names" {
  value = [
    datadog_logs_metric.endpoint_success.name,
    datadog_logs_metric.endpoint_failure.name,
    datadog_logs_metric.request_latency.name,
    datadog_logs_metric.login_success.name,
    datadog_logs_metric.login_failure.name,
    datadog_logs_metric.magic_link_requests.name,
    datadog_logs_metric.magic_link_login_success.name,
    datadog_logs_metric.magic_link_login_failure.name,
    datadog_logs_metric.qr_requests.name,
    datadog_logs_metric.qr_login_success.name,
    datadog_logs_metric.eligibility_requests.name,
    datadog_logs_metric.eligibility_success.name
  ]
}
