# Phase 3 Guide

## What changes from Phase 1

Previously:

```text
module/resource-group/main.tf
# Phase 1 scaffold
```

Now:

```hcl
resource "azurerm_resource_group" "this" {
  ...
}
```

The dev root also calls every real module, so `terraform plan` now has infrastructure to evaluate.

## Step 1 — Sign in to Azure

PowerShell:

```powershell
az login
az account show
```

If you have more than one subscription:

```powershell
az account set --subscription "<subscription-id-or-name>"
```

Check required providers:

```powershell
az provider register --namespace Microsoft.App
az provider register --namespace Microsoft.ContainerRegistry
az provider register --namespace Microsoft.KeyVault
az provider register --namespace Microsoft.OperationalInsights
az provider register --namespace Microsoft.ManagedIdentity
az provider register --namespace Microsoft.Network
```

## Step 2 — Bootstrap Terraform remote state

Run this once:

```powershell
cd terraform/bootstrap-state
terraform init
terraform plan
terraform apply
terraform output
```

This creates a **separate** resource group such as:

```text
rg-observe-tfstate
```

and a storage account/container for Terraform state.

Why separate it?

Destroying:

```text
rg-observe-dev
```

must not destroy the backend storing the state needed to manage that resource group.

## Step 3 — Copy dev variables

```powershell
cd ../environments/dev
Copy-Item terraform.tfvars.example terraform.tfvars
```

Edit values if needed.

## Step 4 — First local-state plan

For the first learning run, keep the backend block commented and run:

```powershell
terraform init
terraform fmt -recursive
terraform validate
terraform plan
```

You should now see actual resources to add.

Expected categories include:

- resource group
- VNet
- delegated subnet
- Log Analytics
- ACR
- managed identity
- role assignments
- Key Vault
- Container Apps environment
- Container App

## Step 5 — Apply

Only after reviewing the plan:

```powershell
terraform apply
```

## Step 6 — Verify

```powershell
terraform output
```

Then:

```powershell
az resource list   --resource-group "$(terraform output -raw resource_group_name)"   --output table
```

PowerShell alternative:

```powershell
$rg = terraform output -raw resource_group_name
az resource list --resource-group $rg --output table
```

## Step 7 — Enable remote backend

After bootstrap works:

1. Uncomment this in `versions.tf`:

```hcl
backend "azurerm" {}
```

2. Copy:

```text
backend.hcl.example
```

to:

```text
backend.hcl
```

3. Replace the storage account placeholder.

4. Run:

```powershell
terraform init -migrate-state -backend-config=backend.hcl
```

## Important bootstrap image behavior

Terraform initially creates the Container App using:

```text
mcr.microsoft.com/k8se/quickstart:latest
```

Why?

Your Java image does not exist in your brand-new ACR yet.

Later CI/CD will:

```text
build Java
  -> docker build
  -> push image to ACR
  -> create candidate ACA revision
```

The Terraform module deliberately ignores later image changes so Terraform does not continually roll the application back to the bootstrap image.

## Why probes are disabled during bootstrap

Your Java application supports:

```text
/api/health/live
/api/health/ready
```

but the temporary Microsoft bootstrap image does not.

Therefore Phase 3 creates the ACA platform with probes disabled.

When the Java image becomes the deployed image, the deployment phase will enable the production probe configuration.
