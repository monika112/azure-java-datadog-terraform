# 6. Naming Conventions

## Azure
| Resource | Pattern | Example |
|---|---|---|
| Resource group | `rg-<app>-<env>` | `rg-observe-prod` |
| TF state RG | `rg-<app>-tfstate` | `rg-observe-tfstate` |
| Container App | `ca-<app>-<env>` | `ca-observe-prod` |
| ACA Environment | `cae-<app>-<env>` | `cae-observe-prod` |
| Managed Identity | `id-<app>-<env>` | `id-observe-prod` |

## Datadog unified tags
```text
service=eligibility-api
env=dev|prod
version=<git-sha>
```

## Business metrics
Prefix with:
```text
app.*
```

Examples:
- `app.magic_link.requests`
- `app.magic_link.login.success`
- `app.qr_code.requests`
- `app.user.endpoint.failure`

## Image tags
Use immutable Git SHA:
```text
<acr>.azurecr.io/eligibility-api:<git-sha>
```
