---
name: fix-client-errors
description: Use when investigating browser/client error logs from Grafana for polygraph or nx-api containers and proposing likely fixes. Requires Grafana MCP; fails hard when unavailable or disconnected. Don't use for backend-only incidents, local-only debugging, or log analysis without Grafana access.
---

# Fix Client Errors

## Procedures

**Step 1: Require Grafana MCP**
1. Inspect the available tools for a connected Grafana MCP server before asking follow-up questions.
2. Fail hard if no Grafana MCP tools/resources are available, if the Grafana MCP server is disabled, or if the first Grafana MCP call reports a connection/auth/datasource failure.
3. State the exact failure and stop. Do not query logs through shell commands, kubectl, ad-hoc HTTP requests, or non-Grafana fallbacks.
4. Proceed only after a successful Grafana MCP call proves the server is connected.

**Step 2: Collect incident scope**
1. Ask the user to select or provide:
   - cluster
   - one or more containers
   - timeframe, including timezone when ambiguous
   - additional prompt/context, if any
2. Use Grafana MCP label/value discovery when available to help the user choose valid clusters and containers.
3. Confirm the final scope in one short line before querying logs.

**Step 3: Derive log searches**
1. Run `python3 scripts/select-log-patterns.py --containers "<comma-separated containers>"` to derive required search terms.
2. Search selected containers with Grafana MCP log tools over the selected timeframe.
3. If any selected container name contains `polygraph`, search for `client-errors` in the logs.
4. If any selected container name contains `nx-api`, search for `nx-cloud/report-client-error` in the logs.
5. If neither target container type is selected, ask for a search string or stop with a clear note that this skill only has built-in patterns for `polygraph` and `nx-api`.
6. Prefer narrow Grafana/Loki queries that filter by cluster, namespace if known, container, timeframe, and search string. Adapt label names to the datasource rather than assuming exact labels.

**Step 4: Extract findings**
1. Group matching log entries by apparent browser error signature, route/path, release/version, user/session identifier if present, and timestamp bucket.
2. Preserve representative log snippets and stack frames. Redact tokens, cookies, emails, and IDs that are not needed for diagnosis.
3. Treat browser stack traces as minified or sourcemap-free unless logs prove otherwise.
4. For `polygraph` findings, map route-like evidence to `apps/polygraph/app/routes` when the repository is available.
5. Produce a concise pre-research summary for the user: scope queried, match counts, top signatures, affected routes, and confidence.

**Step 5: Investigate directly**
1. Research the top findings in the main session after the pre-research summary is prepared.
2. Use sanitized representative logs and stack frames, container/cluster/timeframe/route hints, and repo-specific search hints. No sourcemap is available; keep guesses evidence-weighted.
3. For `polygraph`, prioritize `apps/polygraph/app/routes` plus nearby imports, loaders/actions, client components, and route error boundaries.
4. For `nx-api`, trace the `nx-cloud/report-client-error` ingestion path, error payload shape, and client bundle or frontend source hinted by the payload.

**Step 6: Formulate fixes**
1. Synthesize agent results into one or more likely root causes.
2. Rank proposed fixes by confidence, blast radius, and ease of verification.
3. Clearly separate evidence from educated guesses.
4. Include exact candidate files/functions/routes when available.
5. Include a verification plan: reproduce path, expected log disappearance, targeted tests/typechecks, and Grafana follow-up query. Parallelize only independent verification commands when useful.
6. Ask the user for the next step: implement a selected fix, gather more logs, expand timeframe/containers, or stop.

## Error Handling

* If Grafana MCP is unavailable or disconnected, fail hard and stop without fallback.
* If cluster/container labels cannot be discovered, ask the user for exact label values and continue only through Grafana MCP.
* If log volume is too high, narrow by route, error text, release, namespace, or shorter timeframe before deeper investigation.
* If logs contain sensitive data, redact before sharing with agents or the user.
* If no matches are found, report the exact queries attempted and ask whether to expand timeframe, adjust containers, or provide another search string.
* If agents disagree, present competing hypotheses with evidence and ask which path to pursue.
