---
name: rollout-check
description: Confirm a deployment rolled out successfully after an ArgoCD sync or manual apply. Pass the deployment name as an argument.
metadata:
  author: hsather
  version: "1.0"
---

Verify a deployment rollout completed cleanly using the k8s-mcp tools. The argument after `/rollout-check` is the deployment name (e.g. `/rollout-check jellyfin`).

## Steps

1. **Check rollout status** — call `get_rollout_status` with the deployment name in namespace `default`. Note whether the rollout is complete, in progress, or stalled.

2. **Check pods** — call `list_pods` with namespace `default`. Find pods belonging to the deployment (name starts with the argument). Note phase, ready state, and restart count.

3. **If not healthy** — if any pod is not Running or has restarts > 0:
   - Call `describe_pod` on the unhealthy pod. Note container state and last termination reason.
   - Call `get_pod_logs` with `tail=100`. Look for startup errors, panics, or config failures.
   - Call `get_events` for namespace `default`. Filter for events involving the deployment or its pods.

4. **Report** — produce a concise rollout summary:
   - Rollout status (complete / in-progress / stalled)
   - Pod count (ready/desired), restart count
   - If unhealthy: root cause from logs/events (quoted), recommended action
   - If healthy: confirm with "Rollout complete — N/N pods ready"

## Rules

- If the deployment is not found, say so and list available deployments via `list_deployments`.
- If the rollout is still in progress, say so and give the current pod state — don't wait.
- Lead with the verdict, then evidence. Don't describe steps taken.
