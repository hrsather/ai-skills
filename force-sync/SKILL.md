---
name: force-sync
description: Force an ArgoCD application to sync immediately, then confirm the rollout completed. Pass an app name to sync one app, or no args to sync all.
metadata:
  author: hsather
  version: "1.0"
---

Force an ArgoCD sync using the k8s-mcp tools. The optional argument after `/force-sync` is the ArgoCD app name (e.g. `/force-sync homelab`). If omitted, sync all apps.

## Steps

1. **List apps** — call `list_argocd_apps`. Note current sync and health status for each app.

2. **Trigger sync** — call `sync_argocd_app` for the named app (or for each app if no argument was given).

3. **Confirm rollout** — wait a moment, then for each synced app call `list_deployments` in namespace `default` to check ready/desired counts. If any deployment shows 0/N ready, call `get_rollout_status` on that deployment.

4. **Report** — produce a concise summary:
   - Which apps were synced
   - Before/after sync+health status
   - Any deployments that are not yet fully ready, with rollout status

## Rules

- If `list_argocd_apps` returns no apps, say so and stop.
- If sync_argocd_app fails with a permission error, tell the user the RBAC may not have propagated yet and to retry in 30 seconds.
- Do not check rollout status for apps that were already Synced+Healthy before triggering — only track ones that had OutOfSync or Unknown status.
- Keep the report to one line per app.
