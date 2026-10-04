# Troubleshooting and Debugging History

This file records the real problems encountered while taking the project from local Spring Boot code to a healthy Azure Container Apps deployment with Datadog telemetry.

## Debugging method used

```text
Exact error -> identify failing layer -> smallest fix -> verification command
```

This prevented unrelated changes when failures came from Terraform, Docker, ACR, ACA, or Datadog.

## Terraform initially reported `No changes`

**Symptom**

```text
No changes. Your infrastructure matches the configuration.
```

**Cause**: the original root contained provider/local scaffolding but no effective resource/module declarations.

**Fix**: add real Azure modules/resources and re-run `terraform plan`.

## Datadog Terraform provider lock mismatch

**Symptom**: lock file selected Datadog provider `3.91.0` while configuration required `~> 4.21`.

**Fix**:

```powershell
terraform init -upgrade
terraform providers
terraform validate
```

Do not delete Terraform state to solve a provider lock mismatch.

## Terraform Datadog credentials missing

**Symptom**:

```text
api_key and app_key, bearer_token, or orgUUID must be set
```

**Fix** in the same shell used for Terraform:

```powershell
$env:DD_API_KEY = "..."
$env:DD_APP_KEY = "..."
terraform plan
```

Do not hard-code these keys in the provider block.

## Maven command

The command is `mvn`, not `maven`. Install Maven when `mvn` is missing.

## `wget` unavailable on macOS PowerShell

Use curl:

```powershell
curl -L 'https://dtdg.co/latest-java-tracer' -o dd-java-agent.jar
```

## Java port 8080 already in use

**Symptom**: Spring Boot could not start because port 8080 was occupied.

```powershell
lsof -i :8080
```

Stop the conflicting process or use another local port. This was not a Datadog problem.

## Datadog trace port 8126 conflict

Attempting to run a Docker Datadog Agent failed because `127.0.0.1:8126` was already in use.

```powershell
lsof -nP -iTCP:8126 -sTCP:LISTEN
curl http://localhost:8126/info
```

The machine already had a Datadog Trace Agent, so the extra Docker Agent was unnecessary.

## `dd-java-agent.jar` path check

When Java reported it could not access the agent JAR, verify the current directory and file:

```powershell
Get-Location
Get-ChildItem dd-java-agent.jar
java -jar ./dd-java-agent.jar sampleTrace -c 1
```

A successful diagnostic showed `agent_url=http://localhost:8126` and `agent_error=false` locally.

## ACA revision unhealthy because the image did not exist

**Key system event**:

```text
ImagePullFail ... eligibility-api:v2 ... not found
```

The Docker image had been tagged locally but not successfully pushed to ACR.

Verify and push:

```powershell
az acr repository show-tags --name $acrName --repository eligibility-api --output table
docker push "$acrServer/eligibility-api:v2"
```

## Apple Silicon image architecture

The local image was:

```text
linux/arm64
```

The Azure deployment was rebuilt as `linux/amd64`:

```powershell
docker buildx build `
  --platform linux/amd64 `
  -t "$acrServer/eligibility-api:v2" `
  --push `
  ../../../app
```

The GitHub deploy workflow now enforces `linux/amd64`.

## Docker build context path

From `terraform/environments/dev`, `../app` points to the wrong directory. The project app is three levels up:

```text
../../../app
```

## ACA startup/probe noise from old revisions

System logs repeatedly showed startup-probe failures for an old bootstrap revision. Always check `RevisionName` in every event. Old active revisions with 0% traffic can still create noisy events.

## Datadog API key 403

**Symptom**:

```text
SERVERLESS_INIT | ERROR | API Key invalid (403 response)
```

The first ACA configuration mistakenly produced:

```text
DD_API_KEY=datadog-api-key
```

as a literal value.

Correct configuration is:

```text
DD_API_KEY -> secretRef: datadog-api-key
```

Terraform container env:

```hcl
env {
  name        = "DD_API_KEY"
  secret_name = "datadog-api-key"
}
```

ACA-level secret:

```hcl
secret {
  name                = "datadog-api-key"
  identity            = var.managed_identity_id
  key_vault_secret_id = var.datadog_api_key_secret_id
}
```

Verify:

```powershell
az containerapp revision show `
  --name $app --resource-group $rg `
  --revision <revision-name> `
  --query "properties.template.containers[0].env" `
  --output json
```

The JSON must contain `"secretRef": "datadog-api-key"`, not `"value": "datadog-api-key"`.

## Container started and exited with code 1

ACA showed:

```text
PulledImage -> ContainerCreated -> ContainerStarted -> ProcessExited (1)
```

This moved debugging from Azure/ACR to the process entrypoint.

Inspecting the image verified:

```text
/app/app.jar
/app/datadog-init
/app/dd-java-agent.jar
```

and:

```text
Entrypoint=["/app/datadog-init"]
Cmd=["java","-jar","/app/app.jar"]
```

Running Java directly proved Spring Boot and the Java agent could start. Adding the complete ACA Datadog metadata and correct secret reference produced a healthy later revision.

## Working Datadog tracer state in ACA

Successful startup showed:

```text
service=eligibility-api
agent_url=http://localhost:8126
agent_error=false
logs_correlation_enabled=true
```

Spring Boot then reported Tomcat on port 8080 and `Started ObservabilityApplication`.

## Log message vs structured `event_name`

Datadog displays:

```text
Log Message: http_request_completed
```

but the parsed attributes can be:

```text
event_name=user.endpoint_access_failed
event_category=technical
event_status=error
http_status_code=500
```

Therefore this query is wrong:

```text
@event_name:http_request_completed
```

Use:

```text
service:eligibility-api @event_name:user.endpoint_access_failed
```

The Terraform log metrics now follow the structured taxonomy.

## `/favicon.ico` false signal

Browser requests for `/favicon.ico` can create an application failure event in this demo API. The endpoint failure metric excludes it:

```text
-@endpoint:/favicon.ico
```

For production, consider returning an ordinary 404 for missing static resources instead of counting them as application errors.

## Logs visible but monitors not firing

Monitors are downstream of log-based metrics:

```text
log -> log metric -> custom metric -> monitor
```

If logs arrive but the `@event_name` filter does not match, the custom metric stays empty and the monitor has nothing to evaluate. After changing a log metric definition, generate fresh traffic and verify the metric in Metrics Explorer before troubleshooting the monitor.
