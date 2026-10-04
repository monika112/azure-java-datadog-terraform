resource "datadog_dashboard_json" "application" {
  dashboard = jsonencode({
    title       = "${var.service_name} - ${var.environment} Observability"
    description = "Terraform-managed learning dashboard for API traffic, failures, latency and business telemetry."
    layout_type = "ordered"

    widgets = [
      {
        definition = {
          title = "Successful endpoint calls"
          type  = "query_value"
          requests = [
            {
              response_format = "scalar"
              queries = [
                {
                  data_source = "metrics"
                  name        = "success"
                  query       = "sum:app.user.endpoint.success{*}.as_count()"
                  aggregator  = "sum"
                }
              ]
              formulas = [
                { formula = "success" }
              ]
            }
          ]
          autoscale = true
          precision = 0
        }
      },
      {
        definition = {
          title = "Failed endpoint calls"
          type  = "query_value"
          requests = [
            {
              response_format = "scalar"
              queries = [
                {
                  data_source = "metrics"
                  name        = "failure"
                  query       = "sum:app.user.endpoint.failure{*}.as_count()"
                  aggregator  = "sum"
                }
              ]
              formulas = [
                { formula = "failure" }
              ]
            }
          ]
          autoscale = true
          precision = 0
        }
      },
      {
        definition = {
          title = "API success vs failure"
          type  = "timeseries"
          requests = [
            {
              response_format = "timeseries"
              queries = [
                {
                  data_source = "metrics"
                  name        = "success"
                  query       = "sum:app.user.endpoint.success{*}.as_count()"
                },
                {
                  data_source = "metrics"
                  name        = "failure"
                  query       = "sum:app.user.endpoint.failure{*}.as_count()"
                }
              ]
              formulas = [
                { formula = "success", alias = "Success" },
                { formula = "failure", alias = "Failure" }
              ]
            }
          ]
        }
      },
      {
        definition = {
          title = "Endpoint p95 latency (ms)"
          type  = "timeseries"
          requests = [
            {
              response_format = "timeseries"
              queries = [
                {
                  data_source = "metrics"
                  name        = "latency"
                  query       = "p95:app.user.endpoint.duration{*} by {endpoint}"
                }
              ]
              formulas = [
                { formula = "latency" }
              ]
            }
          ]
        }
      },
      {
        definition = {
          title = "Magic-link requests vs successful login"
          type  = "timeseries"
          requests = [
            {
              response_format = "timeseries"
              queries = [
                {
                  data_source = "metrics"
                  name        = "requests"
                  query       = "sum:app.magic_link.requests{*}.as_count()"
                },
                {
                  data_source = "metrics"
                  name        = "success"
                  query       = "sum:app.magic_link.login.success{*}.as_count()"
                }
              ]
              formulas = [
                { formula = "requests", alias = "Requests" },
                { formula = "success", alias = "Successful logins" }
              ]
            }
          ]
        }
      },
      {
        definition = {
          title = "Recent application errors"
          type  = "log_stream"
          query = local.log_filter
          columns = [
            "service",
            "status",
            "@event_name",
            "@endpoint",
            "@correlation_id"
          ]
          message_display     = "expanded-md"
          show_date_column    = true
          show_message_column = true
          sort = {
            column = "timestamp"
            order  = "desc"
          }
        }
      }
    ]
  })

  depends_on = [
    datadog_logs_metric.endpoint_success,
    datadog_logs_metric.endpoint_failure,
    datadog_logs_metric.request_latency,
    datadog_logs_metric.magic_link_requests,
    datadog_logs_metric.magic_link_login_success
  ]
}
