---
name: pup-datadog
description: Fetch and understand Datadog logs and traces using the pup CLI. Use whenever the user wants to query logs, traces, metrics, monitors, dashboards, or any Datadog data. ALWAYS use the pup CLI — never the Datadog MCP server.
---

# pup-datadog

## Prerequisites

Before using this skill, ensure `pup` is installed and authenticated:

1. Install: follow the instructions at https://docs.datadoghq.com/cli/
2. Authenticate: `pup auth login`
3. Verify: `pup logs search --help`

## Datadog Access via pup CLI

**Always use the `pup` CLI for all Datadog queries.** Never use the Datadog MCP server (`datadog` tools). Run `pup` directly — do not hardcode the binary path (e.g. avoid `/opt/homebrew/bin/pup`).

## Key pup commands

### Logs

```bash
pup logs search --query '<dd_query>' --from <ISO8601_start> --to <ISO8601_end>
# For "last 15 minutes": FROM=$(date -u -v-15M '+%Y-%m-%dT%H:%M:%SZ') && TO=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
```

### APM Traces

```bash
# List traces for a service
pup apm traces list --service my-service --env production --from <ISO8601_start> --to <ISO8601_end>

# Get a single trace by ID
pup apm traces get <trace_id>
```

### Metrics

```bash
pup metrics query --query "avg:system.cpu.user{*}" --from <epoch_seconds> --to <epoch_seconds>
```

### Monitors & Dashboards

```bash
pup monitors list
pup dashboards list
```

### Raw API access

```bash
pup api GET /api/v1/monitor
pup api GET /api/v2/logs/events --data '{"filter":{"query":"status:error"}}'
```

## Workflow

1. Use the `bash` tool to run `pup` commands directly.
2. Parse the JSON output and summarize findings for the user.
3. For log queries from a Datadog URL, extract the `query`, `from_ts`, and `to_ts` parameters from the URL to construct the pup command. Convert millisecond timestamps to ISO 8601.
4. Always run `pup <subcommand> --help` if unsure about flags.

## Known quirks

### `pup logs search` prepends a non-JSON header line

The output starts with a human-readable time range line before the JSON, e.g.:

```
FROM: <start> TO: <end>
{ "data": [...] }
```

**This breaks `jq` and `json.load()` directly.** Always skip the first line before parsing:

```bash
# with jq
pup logs search --query '...' --from <start> --to <end> | tail -n +2 | jq '...'

# with python
pup logs search --query '...' --from <start> --to <end> | tail -n +2 | python3 -c "import json,sys; data=json.load(sys.stdin); ..."
```

Alternatively, save to a file and use `tail -n +2 <file> | ...`.
