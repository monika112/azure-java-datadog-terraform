# Repository Structure

```text
.
├── .github/workflows/
│   ├── ci.yml
│   ├── deploy.yml
│   └── rollback.yml
├── app/
│   ├── Dockerfile
│   ├── dd-java-agent.jar
│   ├── pom.xml
│   └── src/
├── docs/
│   ├── ARCHITECTURE.md
│   ├── DATADOG-SETUP.md
│   ├── DEPLOYMENT-RUNBOOK.md
│   ├── GITHUB-ACTIONS.md
│   ├── TROUBLESHOOTING.md
│   └── ...
├── scripts/
└── terraform/
    ├── bootstrap-state/
    ├── datadog/dev/
    ├── environments/dev/
    └── modules/
```

Generated Terraform state, `.terraform/`, local `.tfvars`, `.env`, build output, and OS/editor files are intentionally excluded by `.gitignore`.
