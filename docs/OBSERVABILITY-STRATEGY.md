# 2. Datadog Observability Strategy

## Telemetry sources

### Application logs
Structured JSON from Spring Boot.

Use for:
- business events
- detailed failures
- request metadata
- clinic/user identifiers where permitted
- correlation IDs
- exception context

### APM / traces
Use for:
- request latency
- controller/service spans
- downstream HTTP calls
- database spans
- error localization
- trace/log correlation

### Azure metrics
Use for:
- CPU
- memory
- replica count
- restarts
- scaling behavior
- platform health

### Business metrics
Examples:
- `app.user.endpoint.success`
- `app.user.endpoint.failure`
- `app.magic_link.requests`
- `app.magic_link.login.success`
- `app.magic_link.login.failure`
- `app.qr_code.requests`
- `app.qr_code.login.success`
- `app.eligibility.requests`
- `app.eligibility.success`

### Datadog events
Use for operational change:
- deployment started
- candidate deployed
- traffic shifted
- promotion completed
- rollback completed

## Telemetry placement

| Data | Logs | Metrics | APM | Datadog Event |
|---|---:|---:|---:|---:|
| clinic_id | Yes | No | Avoid as tag | No |
| request_id | Yes | No | Correlate | No |
| correlation_id | Yes | No | Correlate | No |
| trace_id/span_id | Yes | No | Native | No |
| HTTP status | Yes | Yes | Yes | No |
| request duration | Yes | Distribution | Yes | No |
| login success | Yes | Yes | Trace context | No |
| deployment | Optional | Optional | version correlation | Yes |
| replica count | No | Yes | No | No |

## Metric cardinality

Good metric tags:
- env
- service
- version
- region
- endpoint_name
- status
- event_type

Keep these out of metric tags:
- clinic_id
- user_id
- request_id
- correlation_id
- trace_id
- timestamps
- free-form exception messages

## Unified service tagging
Use:
- `DD_SERVICE=eligibility-api`
- `DD_ENV=dev|prod`
- `DD_VERSION=<git-sha>`
