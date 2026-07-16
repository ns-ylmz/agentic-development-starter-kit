# 0001 — Enforce project policy in two layers: session hooks and CI

- **Status**: Accepted
- **Date**: 2026-07-16
- **Deciders**: Enes Yılmaz

## Context

The same policies (no direct commits to `main`, no force-push, no committed secrets, PR bodies following the template, verified code) can be enforced in two places: locally during a Claude Code session via `.claude/hooks/`, or server-side via `.github/workflows/ci.yml` plus repository settings (`docs/06-repo-settings.md`). Since CI and branch protection already enforce these rules remotely, the question arose whether the local hooks are redundant.

## Decision

Keep both layers. Session hooks are the fast-feedback layer that steers the agent; CI and repository settings are the bypass-proof guarantee. The overlap between them is intentional and only partial.

## Alternatives Considered

- **CI only**: rejected. CI catches violations after they happen — a commit on `main` still has to be untangled locally, a bad PR body produces a red check and an edit round trip, and a pushed secret is compromised even if the check fails (it must be rotated; CI cannot un-leak it). Hooks prevent these at the source and feed the deny reason straight back into Claude's context, so the agent self-corrects within the same session. Several hooks also have no CI equivalent at all: `post-edit-verify.sh` (per-edit eslint feedback) and `guard-domain-boundary.sh` (subagent boundaries are only observable in-session).
- **Hooks only**: rejected. Hooks run only inside Claude Code sessions and can be bypassed locally; they never see a teammate committing by hand or another tool. Branch protection also only covers `main`, so the hook-side force-push guard still adds value for task branches — but without CI there is no enforcement that applies to every contributor unconditionally.

## Consequences

- One rule intentionally exists twice: the PR-body template check (`guard-pr-body.sh` and the CI `pr-template` job). Both read the required headers dynamically from `.github/pull_request_template.md`, so the single source of truth is the template file and the duplication carries no maintenance cost.
- New policies should follow the same pattern: implement the in-session guard in `.claude/hooks/` when early feedback helps the agent, and add the server-side counterpart to CI or repository settings when the rule must hold for every contributor.
- Local hooks may be treated as advisory during development, but CI status checks remain required for merging (see `docs/06-repo-settings.md → Branch Protection`).
