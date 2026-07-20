# Propagating policy updates to downstream repos

This kit is the **single upstream source of truth** for the generic Claude
policy — the hooks, skills, agents, and `.ai/` guidance that should read the
same in every project generated from it. This document describes how a change
made here reaches the downstream repos.

## The rule: kit first, then sync

1. Make the change **here** (in this kit), on a branch, and merge it.
2. Run `scripts/sync-policy.sh <downstream-repo>` for each downstream repo.
3. Review and merge the sync PR it opens in each repo.

Never hand-edit a canonical file directly in a downstream repo — the next sync
would overwrite it. If a downstream discovers an improvement first, **backport
it into this kit**, then let it flow back out through a sync. That keeps the kit
authoritative instead of letting repos drift apart.

## Canonical vs project-owned

Only files listed in [`policy-manifest.txt`](../policy-manifest.txt) are synced.
The split is deliberate:

- **Canonical** — meant to be byte-identical everywhere: `guard-git.sh`,
  `guard-pr-body.sh`, the generic skills, `.ai/task-workflow.md`, etc. These are
  in the manifest.
- **Project-owned** — carry per-project content and must **not** be synced:
  `guard-domain-boundary.sh` (its directory→domain map), the
  `backend-`/`frontend-implementer` agents, project path rules, and project
  docs. These are deliberately absent from the manifest (it lists them at the
  bottom for reference).

When you add a genuinely generic mechanism to the kit, add its path to the
manifest so downstream repos pick it up. When you add something project-shaped,
leave it out.

## Usage

```sh
# Preview what a repo would receive — no writes, no git, no PR:
scripts/sync-policy.sh ../my-app --dry-run

# Open a reviewed sync PR in the target repo:
scripts/sync-policy.sh ../my-app

# Push the sync branch but skip PR creation:
scripts/sync-policy.sh ../my-app --no-pr
```

Run it from your own terminal (not from inside a Claude Code session bound to a
different repo), so the **target** repo's own git guardrails apply. The target
working tree must be clean; the script branches off the target's default branch,
copies only the changed canonical files, commits, pushes, and opens a PR whose
body follows the standard template. If nothing differs, it says so and stops.

## When to reach for something heavier

This script is intentionally simple: a full copy of the canonical set, gated by
a human-reviewed PR. If you later manage many repos or the canonical files start
carrying per-repo variation, graduate to a template-update tool such as
[`cruft`](https://cruft.github.io/cruft/) or [`copier`](https://copier.readthedocs.io/),
which apply only the _delta_ between kit versions and preserve local edits.
