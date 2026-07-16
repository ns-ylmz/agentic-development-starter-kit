# 0004 — Keep CLAUDE.md lean; knowledge in .ai/, mechanisms in .claude/ as pointers

- **Status**: Accepted
- **Date**: 2026-07-16
- **Deciders**: Enes Yılmaz

## Context

Claude Code auto-loads `CLAUDE.md` into every session, which makes it tempting to grow it into the single place for all rules. But everything in it costs context tokens on every request, most rules are only relevant to some tasks, and duplicated guidance (the same rule in CLAUDE.md, a skill, and a doc) drifts apart over time.

## Decision

Guidance is layered, each layer with one owner, and duplication across layers is prohibited:

- `CLAUDE.md` — lean entrypoint: core principles, layer map, mechanism wiring summary. Grows only when the layer map itself changes.
- `.ai/` — the canonical knowledge layer: task workflow, prompt templates, architecture/coding/testing/boundary rules. Split into per-domain files so path-scoped rules can load only what a task needs.
- `.claude/` — mechanisms only (hooks, skills, rules, subagents). Skills and agents reference `.ai/` sections; they never restate them.
- `docs/` — architecture reasoning and ADRs; `planning/` — bounded task plans.

When a document needs guidance owned elsewhere, it references the canonical section instead of restating the rule.

## Alternatives Considered

- **Everything in CLAUDE.md**: rejected. Pays the full token cost on every session, mixes always-relevant principles with rarely-relevant details, and has no mechanism for path-scoped loading.
- **Knowledge inside each skill/agent**: rejected. The same rule would live in several wrappers; updating one and forgetting the others is guaranteed drift. Wrappers as thin pointers pick up template changes automatically on next read.

## Consequences

- Context loading stays proportional: sessions carry the lean CLAUDE.md, and task-relevant `.ai/` files are loaded on demand (path-scoped rules automate part of this).
- Adding guidance means finding its owning layer first (`.ai/README.md → Guidance Ownership`), not appending to CLAUDE.md.
- Mechanism wrappers stay cheap to maintain; changing a prompt template requires no skill edits.
