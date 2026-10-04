# ---------------------------------------------------------------------------
# Log-based metrics
#
# These metrics are computed from structured application logs.
#
# High-cardinality values such as clinic_id, request_id, correlation_id,
# trace_id and span_id are deliberately NOT configured as group_by tags.
# ---------------------------------------------------------------------------

resource "datadog_logs_metric" "endpoint_success" {
  name = "app.user.endpoint.success"

  compute {
    aggregation_type = "count"
  }

  filter {
    query = "${local.log_filter} @event_name:user.endpoint_accessed @event_status:success"
  }

  group_by {
    path     = "@endpoint"
    tag_name = "endpoint"
  }

  group_by {
    path     = "@http_method"
    tag_name = "http_method"
  }
}

resource "datadog_logs_metric" "endpoint_failure" {
  name = "app.user.endpoint.failure"

  compute {
    aggregation_type = "count"
  }

  filter {
    query = "${local.log_filter} @event_name:user.endpoint_access_failed -@endpoint:/favicon.ico"
  }

  group_by {
    path     = "@endpoint"
    tag_name = "endpoint"
  }

  group_by {
    path     = "@http_status_code"
    tag_name = "http_status_code"
  }
}

resource "datadog_logs_metric" "request_latency" {
  name = "app.user.endpoint.duration"

  compute {
    aggregation_type    = "distribution"
    path                = "@duration_ms"
    include_percentiles = true
  }

  filter {
    query = "${local.log_filter} @event_category:technical @duration_ms:*"
  }

  group_by {
    path     = "@endpoint"
    tag_name = "endpoint"
  }
}

resource "datadog_logs_metric" "login_success" {
  name = "app.login.success"

  compute {
    aggregation_type = "count"
  }

  filter {
    query = "${local.log_filter} @event_name:login.success"
  }
}

resource "datadog_logs_metric" "login_failure" {
  name = "app.login.failure"

  compute {
    aggregation_type = "count"
  }

  filter {
    query = "${local.log_filter} @event_name:login.failed"
  }
}

resource "datadog_logs_metric" "magic_link_requests" {
  name = "app.magic_link.requests"

  compute {
    aggregation_type = "count"
  }

  filter {
    query = "${local.log_filter} @event_name:magic_link.requested"
  }
}

resource "datadog_logs_metric" "magic_link_login_success" {
  name = "app.magic_link.login.success"

  compute {
    aggregation_type = "count"
  }

  filter {
    query = "${local.log_filter} @event_name:magic_link.login_success"
  }
}

resource "datadog_logs_metric" "magic_link_login_failure" {
  name = "app.magic_link.login.failure"

  compute {
    aggregation_type = "count"
  }

  filter {
    query = "${local.log_filter} @event_name:magic_link.login_failed"
  }
}

resource "datadog_logs_metric" "qr_requests" {
  name = "app.qr_code.requests"

  compute {
    aggregation_type = "count"
  }

  filter {
    query = "${local.log_filter} @event_name:qr_code.requested"
  }
}

resource "datadog_logs_metric" "qr_login_success" {
  name = "app.qr_code.login.success"

  compute {
    aggregation_type = "count"
  }

  filter {
    query = "${local.log_filter} @event_name:qr_code.login_success"
  }
}

resource "datadog_logs_metric" "eligibility_requests" {
  name = "app.eligibility.requests"

  compute {
    aggregation_type = "count"
  }

  filter {
    query = "${local.log_filter} @event_name:eligibility.requested"
  }
}

resource "datadog_logs_metric" "eligibility_success" {
  name = "app.eligibility.success"

  compute {
    aggregation_type = "count"
  }

  filter {
    query = "${local.log_filter} @event_name:eligibility.success"
  }
}
