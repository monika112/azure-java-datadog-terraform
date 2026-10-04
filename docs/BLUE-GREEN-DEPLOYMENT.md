# 4. Blue/Green Deployment

## Stable
- label: `blue`
- production traffic: 100%

## Candidate
- label: `green`
- production traffic: 0%
- tested through label-specific URL

## Deployment flow
1. Commit code
2. Run CI tests
3. Build immutable image
4. Push image to ACR
5. Create green ACA revision
6. Assign `green` label
7. Wait for startup/readiness
8. Smoke-test green URL
9. Validate Datadog signals
10. Promote
11. Shift traffic
12. Record Datadog deployment event

## Rollback
If regression is detected:
1. shift traffic to blue
2. keep candidate logs/traces
3. record rollback event
4. investigate using Datadog

## Datadog-aware gate
Promotion should verify:
- readiness is healthy
- smoke tests pass
- expected success event appears
- no 5xx spike
- no exception spike
- latency remains acceptable
