# Getting Started

## 1. Verify tools

```powershell
java -version
mvn -version
terraform -version
az version
```

Expected:
- Java 21
- Maven 3.6.3+
- Terraform 1.7+
- Azure CLI installed

## 2. Test the application first

```powershell
cd app
mvn clean test
mvn spring-boot:run
```

Open another terminal:

```powershell
curl http://localhost:8080/api/health/live
curl http://localhost:8080/api/demo/success
curl http://localhost:8080/api/demo/failure
curl http://localhost:8080/api/demo/exception
```

## 3. Test structured correlation

```powershell
curl -i `
  -H "X-Correlation-ID: test-123" `
  http://localhost:8080/api/demo/success
```

The response and JSON logs should contain `test-123`.

## 4. Test business events

```powershell
curl -i `
  -H "Content-Type: application/json" `
  -d '{"clinicId":"CLINIC-123"}' `
  http://localhost:8080/api/magic-link
```

Expected business events:

```text
magic_link.requested
magic_link.sent
```

## 5. Bootstrap Terraform state

```powershell
cd terraform/bootstrap-state
terraform init
terraform plan
terraform apply
```

## 6. Plan Azure infrastructure

```powershell
cd ../environments/dev
Copy-Item terraform.tfvars.example terraform.tfvars

terraform init
terraform fmt -recursive
terraform validate
terraform plan
```

Unlike the old scaffold, this configuration contains real resources and should show resources to add.

## 7. Apply only after reviewing the plan

```powershell
terraform apply
```

## 8. Verify Azure resources

```powershell
terraform output
$rg = terraform output -raw resource_group_name
az resource list --resource-group $rg --output table
```

## 9. Next Datadog implementation area

Use:

```text
terraform/datadog/dev/
```

for Datadog account configuration so Azure and Datadog credentials remain decoupled.
