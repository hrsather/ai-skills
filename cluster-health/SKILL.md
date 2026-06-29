---
name: cluster-health
description: Global cluster health check — nodes, pods across key namespaces, and recent events. Use as a catch-all status check.
metadata:
  author: hsather
  version: "1.0"
---

Check overall cluster health using the k8s-mcp tools.

## Steps

1. **Check nodes** — call `list_nodes`. Note any nodes that are NotReady or have pressure conditions (MemoryPressure, DiskPressure, PIDPressure).

2. **Check pods in each namespace** — call `list_pods` for each of these namespaces: `default`, `argocd`, `kube-system`. Collect any pods that are not in Running or Completed phase (e.g. CrashLoopBackOff, Pending, Error, OOMKilled, Terminating).

3. **Check recent events** — call `get_events` for `default` and `argocd`. Look for Warning-level events: OOMKilled, BackOff, FailedMount, FailedScheduling, Unhealthy, FailedPull.

4. **Report** — produce a concise health summary:
   - Node status (count ready/total, any pressure)
   - Unhealthy pods (namespace, pod name, phase/state, restart count)
   - Notable warning events (quoted, with pod/object name)
   - Overall verdict: Healthy / Degraded / Critical

## Rules

- If all nodes are Ready and all pods are Running or Completed with 0 restarts and no warning events, say "All healthy" and stop.
- Do not list every healthy pod — only surface problems.
- If a namespace returns no pods, note it briefly and move on.
- Keep the report scannable — use a short list per section, not prose.
