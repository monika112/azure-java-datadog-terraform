# Datadog Terraform

This directory contains real Datadog account-side Terraform resources.

It creates:

- log-based metrics from structured application logs
- API failure monitor
- HTTP 5xx monitor
- login failure monitor
- p95 endpoint latency monitor
- application dashboard
- 7-day and 30-day API availability SLO

## Credentials

Do not put Datadog keys in Terraform source or tfvars.

PowerShell:

```powershell
$env:DD_API_KEY = "<api-key>"
$env:DD_APP_KEY = "<application-key>"
```

If your Datadog organization uses a site other than the default, set the appropriate Datadog provider environment/site configuration for your organization.

Check without printing the secret:

```powershell
if ($env:DD_API_KEY) { "DD_API_KEY is set" }
if ($env:DD_APP_KEY) { "DD_APP_KEY is set" }
```

## Run

```powershell
Copy-Item terraform.tfvars.example terraform.tfvars

terraform init
terraform fmt
terraform validate
terraform plan
```

Then review carefully:

```powershell
terraform apply
```

## Important prerequisite

Log-based metrics only begin producing useful metric data after your application logs are actually reaching Datadog.

Therefore the resources can be created before log ingestion is complete, but dashboard graphs and monitors may initially have no data.

## Metric cardinality

These log attributes are intentionally NOT metric group-by dimensions:

- clinic_id
- user_id
- request_id
- correlation_id
- trace_id
- span_id

They should remain searchable in logs/traces.
