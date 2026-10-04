# Phase 2 Application

Request flow:
```text
HTTP request -> RequestTelemetryFilter -> Controller -> Service -> Response
                    |                         |
                    |                         +-> BusinessEventLogger
                    +-> request/correlation IDs
                    +-> final status + duration
                    +-> JSON stdout log
```

Demo endpoints intentionally generate 200, 400, slow and 500 cases for future Datadog exercises.

The login endpoint is training-only. `demo-password` simulates success. It is not real authentication.
