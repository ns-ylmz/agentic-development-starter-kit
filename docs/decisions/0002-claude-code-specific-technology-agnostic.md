# 0002 — Target Claude Code specifically; keep the technology stack open

- **Status**: Accepted
- **Date**: 2026-07-16
- **Deciders**: Enes Yılmaz

## Context

The kit's ancestor (auth-playground) was built tool-agnostic: an `AGENTS.md` entrypoint, `.ai/` docs written for "any agent tool", and hooks documented as reusable by any hook-capable agent. In practice all development happens with Claude Code, and maintaining a tool-abstraction layer added indirection (two entrypoints, hedged wording, hooks living under `.ai/` instead of `.claude/`) without a consumer. Separately, the kit had inherited stack-specific content (NestJS/React/Mongo references) that would not fit every project started from it.

## Decision

The kit is deliberately agnostic on two opposite axes:

- **Not tool-agnostic**: Claude Code is the target. `CLAUDE.md` is the single entrypoint (no `AGENTS.md`), and all mechanisms — hooks, skills, rules, subagents — live under `.claude/`.
- **Technology-agnostic**: TypeScript is the baseline standard, but frontend framework, backend framework, database, and testing tools are project choices. Framework names appear in docs only as examples ("e.g. React"). The default repo shape is a monorepo, but the meaningful layers (`.ai/` docs, `planning/`, tooling configs, CI) carry over to any shape.

## Alternatives Considered

- **Keep the tool-agnostic layer**: rejected. No second agent tool is in use; the abstraction cost (duplicate entrypoints, generic wording, indirect hook paths) was paid on every change while the benefit remained hypothetical. If a second tool ever arrives, extracting a shared layer back out of `.ai/` is straightforward because the knowledge layer itself contains no Claude-specific logic.
- **Fix the stack too (NestJS + React)**: rejected. Projects started from this kit should be free to choose their frameworks; baking a stack in would turn the kit from a working agreement into a project template.

## Consequences

- New mechanisms are added Claude-first, without hedging for other tools.
- Docs must keep framework references at example level; stack decisions belong to each project (recorded in that project's ADRs during `setup-project`).
- If another agent tool is ever adopted, that is a new ADR superseding this one.
