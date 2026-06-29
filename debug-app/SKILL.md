---
name: debug-app
description: Debug a Kubernetes app by inspecting pod state, logs, and events. Pass the app/deployment name as an argument.
metadata:
  author: hsather
  version: "1.0"
---

Debug a Kubernetes app using the k8s-mcp tools. The argument after `/debug-app` is the app name (e.g. `/debug-app jellyfin`).

## Steps

1. **Find the pod** — call `list_pods` with namespace `default`. Match the pod whose name starts with the app name argument.

2. **Describe the pod** — call `describe_pod` with the matched pod name. Note the phase, container ready state, restart count, and container state.

3. **Get logs** — call `get_pod_logs` with `tail=200`. Scan for ERROR, WARN, panic, fatal, exception, or stack traces.

4. **Get events** — call `get_events` for the namespace. Filter for events involving the pod or its owning deployment. Look for OOMKilled, BackOff, FailedPull, FailedMount, or Unhealthy.

5. **Diagnose** — synthesize findings into a short report:
   - Pod phase and container state
   - Restart count and likely cause if > 0
   - Key errors from logs (quote the most relevant lines)
   - Relevant events
   - Recommended action (restart, check config, check storage, etc.)

## Rules

- If no pod matches the app name, say so clearly and list what pods are available.
- If logs are empty, say so and rely on events and describe output.
- Keep the report concise — lead with the most likely root cause.
