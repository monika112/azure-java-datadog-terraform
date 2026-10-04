# Datadog Terraform

Azure infrastructure and Datadog account resources are intentionally separate Terraform roots.

```text
terraform/environments/dev  -> Azure resources and ACA runtime configuration
terraform/datadog/dev       -> Datadog log metrics, monitors, dashboard, SLO
```

This separation lets Azure infrastructure be planned without requiring Datadog App-key permissions.

## Credentials

Set credentials only in the shell/CI secret store:

```powershell
$env:DD_API_KEY = "..."
$env:DD_APP_KEY = "..."
```

Do not commit the values or place them directly in `provider "datadog"`.

## Commands

```powershell
cd terraform/datadog/dev
terraform init -upgrade
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

If the provider lock file contains an older Datadog provider than the configured constraint, `terraform init -upgrade` refreshes the selection.

## Log metrics

The metric filters use **structured log attributes**, for example:

```text
service:eligibility-api env:dev @event_name:user.endpoint_access_failed
```

The visible log message `http_request_completed` is not the `event_name`.

The endpoint failure metric deliberately excludes `/favicon.ico` noise.

## Important sequencing

A monitor based on a log-generated metric cannot fire until:

```text
matching new log
  -> Datadog log metric
  -> custom metric datapoint
  -> monitor evaluation
```

After changing a log metric query, generate fresh traffic and verify the custom metric in Metrics Explorer before debugging the monitor.
