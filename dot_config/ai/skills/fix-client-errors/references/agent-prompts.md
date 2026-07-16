# Diagnosis Agent Prompt Templates

Use these templates only after Grafana MCP queries have produced sanitized findings.

## Polygraph browser error investigation

Investigate a sourcemap-free browser/client error reported by the `polygraph` container.

Inputs:
- Sanitized log snippets:
- Stack frames:
- Route/path hints:
- Cluster/timeframe/container:
- Additional user prompt:

Instructions:
1. Inspect `apps/polygraph/app/routes` first, then follow imports to nearby components, loaders, actions, hooks, and route error boundaries.
2. Treat minified stack frames as hints, not proof.
3. Search for route names, UI text, request paths, action names, and error message fragments from the logs.
4. Return likely violation(s), candidate files/functions, confidence, and a minimal fix proposal.
5. Do not edit files unless the orchestrator explicitly asks for implementation.

Return format:
- `signature`:
- `likely_route`:
- `candidate_files`:
- `hypothesis`:
- `evidence`:
- `confidence`:
- `suggested_fix`:
- `verification`:

## nx-api client error investigation

Investigate a browser/client error reported through `nx-cloud/report-client-error` in the `nx-api` container.

Inputs:
- Sanitized log snippets:
- Request payload clues:
- Stack frames:
- Cluster/timeframe/container:
- Additional user prompt:

Instructions:
1. Trace the `nx-cloud/report-client-error` ingestion path and payload parsing first.
2. Use payload fields, route/path, release, app name, stack frame filenames, and message fragments to locate the likely frontend source.
3. Treat missing sourcemaps as expected; explain each guess and confidence level.
4. Return likely violation(s), candidate files/functions, confidence, and a minimal fix proposal.
5. Do not edit files unless the orchestrator explicitly asks for implementation.

Return format:
- `signature`:
- `payload_clues`:
- `candidate_files`:
- `hypothesis`:
- `evidence`:
- `confidence`:
- `suggested_fix`:
- `verification`:
