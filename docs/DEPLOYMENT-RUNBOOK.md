# Deployment Runbook

## Manual deployment (PowerShell/macOS)

From `terraform/environments/dev`:

```powershell
$acrName   = terraform output -raw acr_name
$acrServer = terraform output -raw acr_login_server
$rg        = terraform output -raw resource_group_name
$app       = terraform output -raw container_app_name
```

Login, build, and push an Azure-compatible image:

```powershell
az acr login --name $acrName

docker buildx build `
  --platform linux/amd64 `
  -t "$acrServer/eligibility-api:v3" `
  --push `
  ../../../app
```

Deploy:

```powershell
az containerapp update `
  --name $app `
  --resource-group $rg `
  --image "$acrServer/eligibility-api:v3"
```

Verify revisions:

```powershell
az containerapp revision list `
  --name $app `
  --resource-group $rg `
  --output table
```

Get the stable ingress FQDN and smoke test:

```powershell
$fqdn = az containerapp show `
  --name $app `
  --resource-group $rg `
  --query properties.configuration.ingress.fqdn `
  --output tsv

curl "https://$fqdn/api/health/live"
curl "https://$fqdn/api/demo/success"
```

## Diagnose an unhealthy revision

1. List revisions and identify the exact failing revision.
2. Read system events for platform/image/probe failures.
3. Read console logs for process/JVM errors.
4. Inspect the revision's image, env vars, and probes.

```powershell
az containerapp logs show --name $app --resource-group $rg --type system --tail 100

az containerapp logs show `
  --name $app --resource-group $rg `
  --revision <revision-name> `
  --type console --tail 100

az containerapp revision show `
  --name $app --resource-group $rg `
  --revision <revision-name> `
  --query "{image:properties.template.containers[0].image,env:properties.template.containers[0].env,probes:properties.template.containers[0].probes}" `
  --output json
```

Always use the exact revision name. System logs can include noisy events from older active revisions.
