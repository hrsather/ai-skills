---
name: argocd
description: Check ArgoCD sync status and debug sync failures by inspecting argocd pods, logs, and events.
metadata:
  author: hsather
  version: "1.0"
---

Inspect ArgoCD health and sync status using the k8s-mcp tools.

## Steps

1. **Find ArgoCD pods** — call `list_pods` with namespace `argocd`. If no pods are found, try namespace `default`.

2. **Check pod health** — call `describe_pod` on `argocd-server` and `argocd-application-controller`. Note any restarts or non-Running states.

3. **Get application controller logs** — call `get_pod_logs` on the `argocd-application-controller-*` pod with `tail=200`. Look for:
   - `ComparisonError`, `SyncFailed`, `FailedSync`
   - Git auth errors, repo unreachable errors
   - Resource hook failures

4. **Get ArgoCD server logs** — call `get_pod_logs` on `argocd-server-*` with `tail=100`. Look for auth errors or API failures.

5. **Get events** — call `get_events` for the `argocd` namespace. Look for failed syncs, webhook errors, or pod failures.

6. **Report** — produce a concise status summary:
   - Overall health (all pods Running?)
   - Last sync result and any errors (quoted from logs)
   - Recommended action (force sync, check git credentials, restart controller, etc.)

## Rules

- If the argocd namespace has no pods, tell the user and stop.
- Quote the specific log lines that indicate the failure — don't paraphrase.
- If everything looks healthy, say so clearly.
