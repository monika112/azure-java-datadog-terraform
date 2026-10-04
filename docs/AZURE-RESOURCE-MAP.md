# Phase 3 Resource Map

```text
Azure Subscription
|
+-- rg-observe-tfstate
|   |
|   +-- Terraform state storage account
|       |
|       +-- tfstate container
|
+-- rg-observe-dev
    |
    +-- vnet-observe-dev
    |   |
    |   +-- snet-aca-dev
    |
    +-- log-observe-dev
    |
    +-- acr<generated>
    |
    +-- kv-observe-dev-<generated>
    |
    +-- id-observe-dev
    |   |
    |   +-- AcrPull on ACR
    |   +-- Key Vault Secrets User on Key Vault
    |
    +-- cae-observe-dev
        |
        +-- ca-observe-dev
            |
            +-- multiple revision mode
            +-- public HTTPS ingress
            +-- bootstrap container
```

## Security choices

### ACR admin account
Disabled.

The application identity receives:

```text
AcrPull
```

instead.

### Key Vault
RBAC authorization enabled.

The application identity receives:

```text
Key Vault Secrets User
```

No secrets are created in Phase 3.

### GitHub
No GitHub Azure secret is created in this phase.

OIDC comes in the CI/CD phase.

### Terraform state
Separated from application resource group.
