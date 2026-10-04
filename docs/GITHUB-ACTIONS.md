# GitHub Actions Setup and Test Guide

## Workflows

### CI (`.github/workflows/ci.yml`)

Runs on pull requests, pushes to `main`, and manual dispatch. It:

1. sets up Java 21;
2. runs `mvn -B clean test`;
3. checks Terraform formatting;
4. initializes and validates all Terraform roots without a backend;
5. fails if Terraform state, `.terraform`, `.env`, `.DS_Store`, or non-example `.tfvars` files are tracked.

### Deploy to ACA (`deploy.yml`)

Manual-only by design so the first repository push cannot unexpectedly change Azure. It:

1. signs in to Azure with GitHub OIDC;
2. discovers the ACR login server;
3. builds `app/Dockerfile` for `linux/amd64`;
4. pushes an immutable image tag (commit SHA by default);
5. runs `az containerapp update`;
6. waits for the latest revision to become `Healthy`;
7. calls `/api/health/live` and `/api/demo/success`.

The explicit `linux/amd64` build prevents the Apple Silicon `linux/arm64` issue encountered during local deployment.

### Rollback (`rollback.yml`)

Manual-only. Supply an existing revision name, for example:

```text
ca-observe-dev--0000008
```

The workflow refuses to route traffic to a revision unless Azure reports it as `Healthy`, then assigns 100% traffic to that revision.

## GitHub repository configuration

Create a GitHub environment named `dev` and configure these Action secrets:

```text
AZURE_CLIENT_ID
AZURE_TENANT_ID
AZURE_SUBSCRIPTION_ID
```

These are identifiers for Azure OIDC login, not a client secret. The federated credential on the Azure identity/service principal must trust this repository/environment.

Create these GitHub Action variables:

```text
AZURE_RESOURCE_GROUP       rg-observe-dev
AZURE_CONTAINER_APP_NAME  ca-observe-dev
AZURE_ACR_NAME             <your ACR name>
```

The OIDC identity needs enough Azure RBAC to update the Container App and push to ACR. A common least-privilege split is deployment rights on the app/resource group plus `AcrPush` on the registry.

The runtime Datadog API key does **not** belong in GitHub Actions: ACA reads it from Key Vault through managed identity.

## First test sequence

1. Push the documentation/workflow commit to a feature branch.
2. Open a pull request and confirm **CI** passes.
3. Merge to `main` only after CI passes.
4. In **Actions -> Deploy to ACA -> Run workflow**, leave `image_tag` empty for the first test.
5. Confirm the job reports a healthy new ACA revision and successful smoke tests.
6. Generate `/api/demo/exception` traffic and verify logs/APM in Datadog.
7. Test rollback by selecting a known healthy older revision and running **Roll back ACA traffic**.

## Troubleshooting workflow failures

- `azure/login`: verify OIDC federated credential, client/tenant/subscription IDs, and `id-token: write`.
- `az acr login` or push: verify `AcrPush` for the workflow identity.
- ACA image pull: verify the ACA managed identity still has `AcrPull` on ACR.
- New revision unhealthy: inspect ACA system logs and container console logs before changing probes.
- Smoke test fails while revision is healthy: inspect FQDN, ingress target port 8080, and Spring endpoints.

## Local pre-push checks

```bash
cd app && mvn clean test
cd ../terraform/environments/dev && terraform fmt -recursive && terraform validate
cd ../../datadog/dev && terraform validate
```

Also run:

```bash
git status
git ls-files | grep -E 'terraform.tfstate|/\.terraform/|\.tfvars$|\.env$'
```

The final command should not list local state or secret-bearing files.
