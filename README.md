# Java + Azure Container Apps + Datadog Observability Lab

This repository is a working learning project for deploying a Java 21 / Spring Boot API to Azure Container Apps (ACA) and observing it in Datadog with structured logs, APM traces, log-based metrics, dashboards, monitors, and Azure platform telemetry.

## Current working state

The validated runtime path is:

```text
Client request
  -> Azure Container Apps ingress
  -> Spring Boot application
  -> Datadog Java tracer
  -> Datadog serverless-init
  -> Datadog
       -> Logs
       -> APM traces
       -> log-based custom metrics
       -> dashboards / monitors
```

The application has been deployed successfully as a healthy ACA revision and Datadog receives application logs with `service:eligibility-api`, `env:dev`, ACA tags, and trace correlation.

## Repository structure

```text
app/                         Spring Boot application and Dockerfile
terraform/bootstrap-state/   optional remote-state bootstrap
terraform/environments/dev/  Azure infrastructure root
terraform/modules/           reusable Azure modules
terraform/datadog/dev/       Datadog metrics, monitors, dashboard and SLO
.github/workflows/            CI, ACA deploy, rollback
scripts/                      local smoke/validation helpers
docs/                         architecture, runbooks and troubleshooting
```

## Application endpoints

```text
GET  /api/health/live
GET  /api/health/ready
GET  /api/demo/success
GET  /api/demo/failure
GET  /api/demo/slow
GET  /api/demo/exception
POST /api/login
POST /api/magic-link
POST /api/qr-code
GET  /api/eligibility/{clinicId}
POST /api/eligibility
```

## Local development

```bash
cd app
mvn clean test
mvn spring-boot:run
```

Test:

```bash
curl http://localhost:8080/api/health/live
curl http://localhost:8080/api/demo/success
```

### Local Datadog Java tracing

When a local Datadog Agent is listening on `localhost:8126`:

```bash
export DD_SERVICE=eligibility-api
export DD_ENV=dev
export DD_VERSION=local
java -javaagent:dd-java-agent.jar -jar target/eligibility-api-0.0.1-SNAPSHOT.jar
```

## Azure infrastructure

`terraform/environments/dev` provisions the VNet/subnet, Log Analytics, ACR, user-assigned managed identity, Key Vault, Container Apps Environment, and Container App. The ACA identity receives `AcrPull` and `Key Vault Secrets User`.

The Datadog API key is **not stored in Terraform source**. ACA references the versionless Key Vault secret URI `.../secrets/datadog-api-key` and exposes it to the app as a secret-backed `DD_API_KEY` environment variable.

```bash
cd terraform/environments/dev
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

## Required ACA Datadog variables

```text
DD_API_KEY                secretRef: datadog-api-key
DD_SITE                   datadoghq.com
DD_SERVICE                eligibility-api
DD_ENV                    dev
DD_VERSION                v3
DD_LOGS_ENABLED           true
DD_LOGS_INJECTION         true
DD_SOURCE                 java
DD_AZURE_SUBSCRIPTION_ID  current Azure subscription
DD_AZURE_RESOURCE_GROUP   current resource group
JAVA_TOOL_OPTIONS         -javaagent:/app/dd-java-agent.jar
```

The Docker image uses Datadog `serverless-init` as its entrypoint and includes `dd-java-agent.jar`.

## Datadog Terraform

From `terraform/datadog/dev`, set credentials in the shell; do not commit them:

```bash
export DD_API_KEY='...'
export DD_APP_KEY='...'
terraform init -upgrade
terraform plan
terraform apply
```

The configuration creates log-based metrics, monitors, a dashboard, and an availability SLO. Metric filters use structured attributes such as `@event_name:user.endpoint_access_failed`; the visible message text `http_request_completed` is not the `event_name`.

## GitHub Actions

- `CI`: Maven tests + Terraform format/validation + repository safety checks.
- `Deploy to ACA`: manual deployment, Azure OIDC, linux/amd64 Docker build, ACR push, ACA revision rollout, health wait, smoke test.
- `Roll back ACA traffic`: manually route 100% traffic to a selected healthy revision.

See [docs/GITHUB-ACTIONS.md](docs/GITHUB-ACTIONS.md) before running them.

## Documentation

Start with:

- [Build everything again from zero](docs/BUILD-FROM-SCRATCH.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Datadog setup](docs/DATADOG-SETUP.md)
- [Deployment runbook](docs/DEPLOYMENT-RUNBOOK.md)
- [GitHub Actions](docs/GITHUB-ACTIONS.md)
- [Troubleshooting history](docs/TROUBLESHOOTING.md)
- [Logging](docs/LOGGING.md)
- [Business event model](docs/BUSINESS-EVENT-MODEL.md)

## Repository security

Do not commit Terraform state, `.terraform/`, `.tfvars`, `.env`, API keys, App keys, or Azure credentials. `.gitignore` and CI checks guard against these files, but review `git status` before every push.
