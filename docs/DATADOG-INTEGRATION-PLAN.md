# Datadog Integration Status

This file originally described future work. The core integration is now implemented.

## Implemented

- Datadog `serverless-init` in the ACA application image.
- Datadog Java tracer via `/app/dd-java-agent.jar`.
- ACA `DD_*` environment variables and Azure resource metadata.
- Key Vault-backed `DD_API_KEY` using ACA `secretRef` and managed identity.
- Structured JSON application logs in Datadog.
- APM tracer connectivity from ACA (`agent_error=false`).
- Trace/log correlation.
- Terraform-managed log-based metrics, monitors, dashboard, and SLO under `terraform/datadog/dev`.
- Azure Container Apps HTTP/platform logs visible with ACA resource tags.

## Validation chain

```text
HTTP request
  -> ACA
  -> Spring Boot
  -> APM trace + structured log
  -> Datadog
  -> log-based metric
  -> dashboard / monitor
```

## Remaining improvements

- Tune monitor thresholds from real traffic baselines.
- Add a deployment event/marker after successful GitHub deployment.
- Harden `/favicon.ico` / missing-static-resource behavior so it returns a normal 404.
- Add an automated observability gate before blue/green traffic promotion.
- Expand Azure platform metric dashboards if needed.

See `DATADOG-SETUP.md` and `TROUBLESHOOTING.md` for the working configuration and debugging history.
