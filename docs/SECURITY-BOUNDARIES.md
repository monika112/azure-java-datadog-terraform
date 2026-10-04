# 5. Security Boundaries

## GitHub -> Azure
Use Azure OIDC workload identity federation.

Do not keep long-lived Azure client secrets in GitHub.

## ACA -> ACR
Use managed identity with least-privilege ACR pull permission.

## ACA -> Key Vault
Use managed identity with least-privilege secret access.

## ACA -> Datadog
Only inject a Datadog API key if the selected telemetry path requires one.

## Never store secrets in
- source code
- Dockerfile
- application.properties
- Terraform source
- Git history
- shell scripts

## Logging security
Do not log:
- passwords
- tokens
- authorization headers
- full request bodies by default
- personal/health data
- secrets

## Network posture
- HTTPS only
- private networking where practical
- identity-based Azure access
- public ingress only at intended edge
- no exposure of management endpoints
