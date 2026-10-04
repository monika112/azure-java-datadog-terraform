# Architecture Diagrams

Mermaid source:
- `architecture.mmd`
- `blue-green.mmd`
- `telemetry-flow.mmd`
- `security-boundaries.mmd`
- `e2e-datadog-connectivity.mmd`

Graphviz source:
- `architecture.dot`
- `blue-green.dot`
- `telemetry-flow.dot`
- `security-boundaries.dot`
- `e2e-datadog-connectivity.dot`

Rendered PNGs:
- `architecture.png`
- `blue-green.png`
- `telemetry-flow.png`
- `security-boundaries.png`
- `e2e-datadog-connectivity.png`

## What each diagram shows

- **architecture**: full platform view across Azure, Datadog, Terraform, and GitHub Actions.
- **blue-green**: revision strategy and traffic promotion / rollback.
- **telemetry-flow**: logs, traces, metrics, dashboards, and monitors.
- **security-boundaries**: secret flow, identities, and platform boundaries.
- **e2e-datadog-connectivity**: request → app → Datadog → metric → monitor end-to-end connectivity.
