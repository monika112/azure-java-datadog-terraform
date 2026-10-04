# Datadog Setup for Azure Container Apps

## Runtime architecture

```text
Azure Container App revision
  /app/datadog-init              top-level process
  /app/dd-java-agent.jar         Java tracing agent
  /app/app.jar                   Spring Boot API
           |
           +--> APM traces
           +--> JSON application logs
           +--> business / technical events
           v
        Datadog
```

The application image uses:

```dockerfile
ENTRYPOINT ["/app/datadog-init"]
CMD ["java","-jar","/app/app.jar"]
```

and:

```text
JAVA_TOOL_OPTIONS=-javaagent:/app/dd-java-agent.jar
```

## ACA environment variables

The working revision contains:

```text
DD_API_KEY                secretRef: datadog-api-key
DD_SITE                   datadoghq.com
DD_SERVICE                eligibility-api
DD_ENV                    dev
DD_VERSION                v3
DD_LOGS_ENABLED           true
DD_LOGS_INJECTION         true
DD_SOURCE                 java
DD_AZURE_SUBSCRIPTION_ID  <subscription ID>
DD_AZURE_RESOURCE_GROUP   rg-observe-dev
JAVA_TOOL_OPTIONS         -javaagent:/app/dd-java-agent.jar
```

`DD_API_KEY` must be a secret reference. A previous broken revision used the literal value `datadog-api-key`, causing Datadog intake to return HTTP 403.

## Key Vault path

Create the secret outside source control:

```powershell
az keyvault secret set `
  --vault-name $kv `
  --name datadog-api-key `
  --value $env:DD_API_KEY
```

Terraform references the versionless URI:

```text
https://<vault>.vault.azure.net/secrets/datadog-api-key
```

ACA's user-assigned managed identity must have `Key Vault Secrets User` on the vault.

## Verify ACA runtime configuration

```powershell
az containerapp revision show `
  --name $app `
  --resource-group $rg `
  --revision <revision-name> `
  --query "properties.template.containers[0].env" `
  --output table
```

Expected for the key:

```text
Name        SecretRef
DD_API_KEY  datadog-api-key
```

## Verify APM

The Java tracer startup line should show:

```text
service=eligibility-api
agent_url=http://localhost:8126
agent_error=false
logs_correlation_enabled=true
```

Then generate traffic:

```powershell
curl "https://$fqdn/api/demo/success"
curl "https://$fqdn/api/demo/slow"
curl "https://$fqdn/api/demo/exception"
```

In Datadog, check `APM -> Services -> eligibility-api`, filtered by `env:dev`.

## Verify logs and event taxonomy

A log can display the message:

```text
http_request_completed
```

while its structured attributes contain:

```text
event_name=user.endpoint_access_failed
event_category=technical
event_status=error
endpoint=/api/demo/exception
http_status_code=500
duration_ms=...
```

Use the structured attribute in searches and log metrics:

```text
service:eligibility-api @event_name:user.endpoint_access_failed
```

Do not search for `@event_name:http_request_completed`; that string is the human-facing message.

## Trace/log correlation

Application logs include Datadog trace correlation when a request has an active trace. In the Datadog UI, an application log should show a Trace ID and link back to the matching trace.

## Log-based metrics

Terraform creates metrics including:

```text
app.user.endpoint.success
app.user.endpoint.failure
app.user.endpoint.duration
app.login.success
app.login.failure
app.magic_link.requests
app.qr_code.requests
app.eligibility.requests
app.eligibility.success
```

`/favicon.ico` is excluded from the endpoint failure log metric because browsers can request it automatically and it is not a meaningful API failure.

After changing a log metric query, generate **new** traffic and then inspect Metrics Explorer. Monitors depend on these custom metrics, so logs can be healthy while monitors remain empty if the metric query does not match the structured log attributes.
