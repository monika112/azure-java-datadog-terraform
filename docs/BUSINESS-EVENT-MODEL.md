# 3. Business Event Model

## Standard fields
- event_name
- event_category
- event_status
- event_version
- service
- environment
- application_version
- endpoint
- http_method
- http_status_code
- duration_ms
- clinic_id
- request_id
- correlation_id
- trace_id
- span_id
- error_type
- error_message
- timestamp

## Event taxonomy

### Endpoint access
- `user.endpoint_accessed`
- `user.endpoint_access_failed`

### Login
- `login.requested`
- `login.success`
- `login.failed`

### Magic link
- `magic_link.requested`
- `magic_link.sent`
- `magic_link.login_success`
- `magic_link.login_failed`

### QR code
- `qr_code.requested`
- `qr_code.generated`
- `qr_code.login_success`
- `qr_code.failed`

### Eligibility
- `eligibility.requested`
- `eligibility.success`
- `eligibility.failed`

### Application health
- `application.started`
- `application.ready`
- `application.not_ready`

## Example event
```json
{
  "event_name": "magic_link.login_success",
  "event_category": "business",
  "event_status": "success",
  "event_version": "1",
  "service": "eligibility-api",
  "environment": "prod",
  "application_version": "a91e28d",
  "endpoint": "/api/login",
  "http_method": "POST",
  "http_status_code": 200,
  "duration_ms": 124,
  "clinic_id": "CLINIC-123",
  "correlation_id": "8a9b...",
  "trace_id": "123456789",
  "span_id": "987654321",
  "timestamp": "2026-10-02T20:00:00Z"
}
```

## Security rule
Never log passwords, authorization headers, JWTs, magic-link tokens, secrets, API keys, or sensitive health/personal data.
