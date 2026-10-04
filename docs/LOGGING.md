# Phase 2 Logging

Every request produces a technical event such as:
```json
{"message":"http_request_completed","event_name":"user.endpoint_accessed","event_category":"technical","event_status":"success","service":"eligibility-api","env":"local","version":"local","correlation_id":"...","endpoint":"/api/demo/success","http_status_code":"200","duration_ms":"8"}
```

Business example:
```json
{"message":"business_event","event_name":"magic_link.requested","event_category":"business","event_status":"requested","clinic_id":"CLINIC-123"}
```

Use `DD_SERVICE`, `DD_ENV`, and `DD_VERSION` now; the Datadog Java agent will later add trace/span correlation.

Do not turn `clinic_id`, `request_id`, `correlation_id`, user IDs or trace IDs into metric tags.
