#!/usr/bin/env bash
set -euo pipefail
B="${BASE_URL:-http://localhost:8080}"
curl -fsS -i "$B/api/health/live"; echo
curl -fsS -i "$B/api/health/ready"; echo
curl -fsS -i -H 'X-Correlation-ID: phase2-demo-123' "$B/api/demo/success"; echo
curl -sS -i "$B/api/demo/failure"; echo
curl -fsS -i "$B/api/demo/slow"; echo
curl -sS -i "$B/api/demo/exception"; echo
curl -fsS -i -H 'Content-Type: application/json' -d '{"clinicId":"CLINIC-123"}' "$B/api/magic-link"; echo
curl -fsS -i -H 'Content-Type: application/json' -d '{"clinicId":"CLINIC-123"}' "$B/api/qr-code"; echo
curl -fsS -i "$B/api/eligibility/CLINIC-123"; echo
curl -fsS -i -H 'Content-Type: application/json' -d '{"username":"demo-user","password":"demo-password"}' "$B/api/login"; echo
curl -sS -i -H 'Content-Type: application/json' -d '{"username":"demo-user","password":"wrong"}' "$B/api/login"; echo
