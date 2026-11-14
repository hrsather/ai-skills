# ai-skills

A Claude Code plugin marketplace of generic, public skills.

## Install

```
/plugin marketplace add hrsather/ai-skills
/plugin install sdlc@ai-skills
```

Or in `~/.claude/settings.json`:

```json
"extraKnownMarketplaces": {
  "ai-skills": { "source": { "source": "github", "repo": "hrsather/ai-skills" } }
},
"enabledPlugins": { "sdlc@ai-skills": true }
```

## Plugins

### sdlc

A spec-first pipeline for agentic coding. `ship` is the entry point and runs the others in order:

| Skill | Role |
|---|---|
| `ship` | The pipeline: worktree → spec → design → build → review → green → reach out → log → clean up |
| `grill-me` | Interview until the task is specified, then write `SPEC-<worktree>.md` |
| `propose-options` | Three designs from Sonnet agents, an Opus judge picks one |
| `pre-push-review` | Fresh Opus review of the branch before it goes to GitHub |
| `pr-review-loop` | Fix AI review comments and failing checks, capped at 5 rounds |
| `handoff` | Write `HANDOFF-<worktree>.md` for the next session |
| `unblock` | Draft an ask for a person when Claude is truly stuck |

Hooks:
- `SessionStart`: points a new session at the worktree's `HANDOFF-` and `SPEC-` files.
- `PreToolUse` on `git push`: runs the repo's pre-commit and package checks, and blocks the push on failure.

## Develop

Test local changes without pushing:

```
claude --plugin-dir ./plugins/sdlc
```

`pre-commit` validates each `SKILL.md` frontmatter and the marketplace and plugin manifests.
