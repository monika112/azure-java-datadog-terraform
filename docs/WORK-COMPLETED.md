# Work Completed So Far

## Application

- Java 21 / Spring Boot API with health, demo, login, magic-link, QR-code, and eligibility endpoints.
- Structured JSON logging, correlation/request IDs, safe exception handling, technical events, and business events.
- Datadog Java tracer packaged into the image.
- Datadog serverless-init used as container entrypoint.

## Azure

- Terraform modules for resource group, VNet/subnet, Log Analytics, ACR, managed identity, Key Vault, Container Apps Environment, and Container App.
- Managed identity uses `AcrPull` and `Key Vault Secrets User`.
- Multiple revision mode and public ingress on port 8080.
- Working image built for `linux/amd64` and deployed as a healthy revision.

## Datadog

- ACA runtime variables and Key Vault-backed `DD_API_KEY`.
- Java APM connectivity verified with `agent_error=false`.
- Application logs visible in Datadog with ACA tags and trace IDs.
- Terraform-managed log-based metrics, dashboard, monitors, and SLO.
- Correct event-query taxonomy established (`event_name` vs log message).

## Delivery automation

- CI workflow for Java tests and Terraform validation.
- Manual OIDC-based ACA deployment workflow with ACR push, healthy revision wait, and smoke tests.
- Manual revision rollback workflow.

See `TROUBLESHOOTING.md` for the detailed debugging history.
