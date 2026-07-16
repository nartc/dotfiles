---
name: polygraph-prod-monitoring
description: Use when monitoring Polygraph production health in Grafana, especially nxcloud prod NA, triaging /prepare.data failures, client browser errors, observability gaps, or deciding whether gcx findings warrant Linear follow-up. Do not use for local-only Polygraph dev or non-production debugging.
---

# Polygraph Prod Monitoring

## Overview

Monitor Polygraph in production by collecting Grafana evidence with `gcx`, separating findings into stable buckets, and turning verified issues into Linear tickets. Do not overclaim from logs, minified browser stacks, or metric absence without confirming the matching infra path.

## Default Scope

Use these defaults unless the user gives different values:

| Field | Value |
| --- | --- |
| Grafana context | `nx-cloud` |
| Prometheus datasource | `Prod Metrics` / `ce8ih6z8g4ttsa` |
| Loki datasource | `Prod Logs` / `ee8ih70grtypsb` |
| cluster | `nxcloudprod-app-na` |
| environment | `prod` |
| region | `us-east1` |
| namespace | `default` |
| Polygraph container | `polygraph` |
| nx-api container | `nx-cloud-nx-api` |
| Linear team | `RedPanda` / `NXA` |
| Linear project | `Polygraph Standalone` |

## Workflow

1. Use `gcx` for Grafana checks. Start with `gcx config check --context nx-cloud`. Investigate the buckets directly; parallelize only independent command executions when that materially reduces elapsed time.
2. Keep findings in four separate buckets:
   - infra/container health
   - demo provisioning `/prepare.data` failures
   - client/browser errors
   - observability/instrumentation gaps
3. For each bucket, capture:
   - time window
   - exact query or log filter
   - numeric result
   - representative timestamps and correlation IDs when available
   - interpretation and confidence
4. Store reviewable artifacts under `tmp/` when doing a long investigation:
   - `tmp/polygraph-prod-na-bucket-1-infra-container-health.html`
   - `tmp/polygraph-prod-na-bucket-2-demo-provisioning-prepare-failures.html`
   - `tmp/polygraph-prod-na-bucket-3-client-browser-errors.html`
   - `tmp/polygraph-prod-na-bucket-4-observability-instrumentation-gaps.html`
5. Ask the user before creating or updating Linear tickets unless they already asked for ticket changes.
6. Keep final status simple:
   - green: no user-facing issue and observability sufficient
   - yellow: degraded, intermittent, or visibility gap
   - red: ongoing user-facing failure, paging condition, or high-volume regression

## gcx Command Shape

Use the `gcx` skill before changing command forms. Do not guess flags; run `gcx metrics query --help` or `gcx logs query --help` before adding time-window flags.

Known query shape:

```bash
gcx metrics query --context nx-cloud -d ce8ih6z8g4ttsa '<promql>' -o json
```

```bash
gcx logs query --context nx-cloud -d ee8ih70grtypsb '<logql>' -o json
```

For exact time ranges, first discover supported flags with command help, then record those flags in the bucket evidence.

## Bucket Checks

### 1. Infra / Container Health

Check both Polygraph and nx-api:

```promql
kube_deployment_status_replicas_available{cluster="nxcloudprod-app-na", namespace="default", deployment=~"polygraph|nx-cloud-nx-api"}
```

```promql
kube_pod_container_status_restarts_total{cluster="nxcloudprod-app-na", namespace="default", container=~"polygraph|nx-cloud-nx-api"}
```

```promql
container_memory_working_set_bytes{cluster="nxcloudprod-app-na", namespace="default", container=~"polygraph|nx-cloud-nx-api"}
```

Also check unready/OOM signals and active alerts when available. Stable replicas plus zero restarts/OOM means no infra degradation found from these checks; keep memory trends as watch items if they are rising.

### 2. Demo Provisioning `/prepare.data`

Use logs to bucket requests by status and error reason. Capture examples with timestamp and correlation ID.

Common signatures:

- route/path: `/prepare.data`
- error kind: `upstream_github_operation_failed`
- server route: `apps/polygraph/app/routes/_default.prepare.tsx`
- upstream call: `libs/polygraph/data-access-api/src/lib/provision-polygraph-demo-organization.server.ts`
- nx-api handler/service:
  - `apps/nx-api/src/main/kotlin/handlers/polygraph/PolygraphDemoHandlers.kt`
  - `apps/nx-api/src/main/kotlin/services/polygraph/PolygraphDemoService.kt`

Recommend a ticket when failures are user-facing, recurring, or lack enough correlation to debug. Treat recurring as either `>=2` matching 5xx responses in the chosen window or the same signature appearing in multiple windows. Do not page if the final hour is mostly clean unless failures are severe.

### 3. Client / Browser Errors

Follow `fix-client-errors` when Grafana MCP is available. If only logs/gcx are available, use no-sourcemap caution:

- Treat minified/browser stack traces as signatures, not exact component roots.
- React errors like `#418` / `#423` indicate hydration/recoverable render issues, but need route + timing correlation.
- Separate client report route volume from distinct browser error signatures.

Relevant files:

- `apps/polygraph/app/entry.client.tsx`
- `apps/polygraph/app/root.tsx`
- `apps/polygraph/app/routes/_resource.client-errors.tsx`
- `libs/ocean/util-misc/src/lib/client/client-error-reporting.ts`
- `apps/polygraph/app/routes/embed.login.tsx`
- `apps/polygraph/app/components/polygraph-login-background.tsx`

Recommend a ticket if errors spike, persist across windows, affect login/prepare/org routes, or are repeatedly reported by the client reporter. If baseline is unknown, treat `>=10` client reports/hour or the same signature across multiple windows as ticket-worthy evidence; otherwise summarize and ask.

### 4. Observability / Instrumentation Gaps

Verify what infra already captures before recommending a metrics implementation.

Known baseline:

- nx-cloud frontend app metrics exist via OpenTelemetry-style series under `job="frontend"`.
- Polygraph currently has kube/cAdvisor metrics only.
- `apps/nx-cloud/server.js` has legacy `express-prom-bundle` code; do not copy it as the primary recommendation.
- `apps/nx-cloud/server-libs/otel.server.js` is the relevant model for frontend OTel bootstrap.

Frontend verification queries:

```promql
target_info{cluster="nxcloudprod-app-na", job="frontend"}
```

```promql
http_server_duration_milliseconds_count{cluster="nxcloudprod-app-na", job="frontend"}
```

```promql
nodejs_eventloop_utilization_ratio{cluster="nxcloudprod-app-na", job="frontend"}
```

Polygraph absence checks:

```promql
target_info{cluster="nxcloudprod-app-na", k8s_pod_name=~"polygraph-.*"}
```

```promql
{__name__=~"http_server_duration_milliseconds.*|http_client_.*|nodejs_.*|v8js_.*|process_.*", cluster="nxcloudprod-app-na", k8s_pod_name=~"polygraph-.*"}
```

If frontend queries return data and Polygraph app-level queries are empty, state that Polygraph app metrics were not found via these verified label paths. Recommend Polygraph joining the existing OTel path first. A direct `prom-client` `/metrics` endpoint is only a fallback if infra cannot ingest Polygraph OTel metrics.

## Linear Ticket Template

Create tickets in `RedPanda` / `NXA`, project `Polygraph Standalone`. Before creating, search existing issues for the same route/signature. Create or update only when the user explicitly requested ticket changes or confirms the draft.

Use this structure:

```markdown
## Context

[What was observed and why it matters.]

## Evidence

- Time window:
- Datasource:
- Query/log filter:
- Result:
- Representative timestamps/correlation IDs:

## Findings

- [Verified facts only]

## Relevant files

- `path/to/file`

## Proposed approach

1. [First investigation/fix step]
2. [Second step]

## Acceptance criteria

- [Observable outcome]
- [Bounded labels/no sensitive IDs when metrics are involved]
```

For observability tickets, include this correction when relevant:

> nx-cloud/frontend metrics are already captured as OTel-style metrics under `job="frontend"`. Polygraph should align with that OTel/infra path first; direct `prom-client` is a fallback, not the default.

## Decision Rules

| Finding | Action |
| --- | --- |
| infra down, replicas unavailable, OOM/restarts | red; investigate immediately |
| `/prepare.data` 500s recurring | recommend ticket with log evidence; create/update only after confirmation |
| `/prepare.data` only one final-hour failure | yellow/watch unless user impact is severe |
| browser errors spike or hit auth/prepare/org routes | recommend ticket; apply no-sourcemap caution |
| Polygraph has only kube metrics | recommend observability ticket |
| nx-cloud frontend has OTel app metrics | use OTel parity as model |

## Error Handling

- If `gcx config check --context nx-cloud` fails, stop and report the context/connectivity problem before interpreting metrics.
- If a `gcx` query fails due to unknown flags, run the command's `--help`, correct the command, and include the corrected command in evidence.
- If Grafana MCP is unavailable, do not claim `fix-client-errors` ran. Use gcx/log evidence only and state the limitation.
- If Linear team/project lookup fails, stop and ask rather than creating an issue in a guessed location.
- If metrics are empty, verify datasource, cluster, job/pod label path, and comparison service before calling it an instrumentation gap.

## Common Mistakes

- Do not claim Polygraph has no metrics at all; it has kube/cAdvisor infra metrics.
- Do not claim nx-cloud frontend metrics come from `express-prom-bundle` unless metric names prove it.
- Do not recommend copying middleware registered after a catch-all route.
- Do not create or update Linear issues without explicit user confirmation unless the user already requested ticket changes.
- Do not put org, repo, workflow, session, correlation, or trace IDs in metric labels.
- Do not treat minified React browser errors as exact source locations without sourcemaps.
- Do not merge all findings into one giant ticket; keep infra, provisioning, client errors, and observability separate.
