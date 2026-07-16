# 0003 — Scope path aliases per workspace; no cross-workspace aliases

- **Status**: Accepted
- **Date**: 2026-07-16
- **Deciders**: Enes Yılmaz

## Context

The kit's ancestor (auth-playground) defined root-level TypeScript path aliases that resolved across workspaces (`@backend/*`, `@frontend/*`, `@shared/*` in the root `tsconfig.base.json`). This works, but it lets any workspace import any other workspace's internals with one line, silently eroding the boundaries the rest of the kit enforces (domain-boundary docs, `guard-domain-boundary.sh`, isolated implementer subagents).

## Decision

Path aliases are scoped per workspace. Each app/package defines its own aliases in its own tsconfig, and those aliases may only resolve into that workspace's own `src/`. Cross-workspace imports go exclusively through the shared package's public entrypoint, declared as a real workspace dependency (`import { X } from '@scope/shared'`). The root `tsconfig.base.json` deliberately contains no `paths`.

## Alternatives Considered

- **Root-level cross-workspace aliases (the ancestor's pattern)**: rejected. Convenient, but it makes boundary violations the path of least resistance, bypasses the shared package's public API, couples build/test configs of all workspaces to one root mapping, and breaks independent extraction of a workspace.
- **No aliases at all**: rejected as too strict. In-workspace aliases (e.g. `@/*` → `./src/*`) are harmless and improve readability; the problem is only aliases that cross a boundary.

## Consequences

- Every workspace stays independently buildable, testable, and extractable.
- The shared package's public entrypoint is the only cross-workspace contract surface, which keeps `.ai/shared-domain-boundaries.md → Consumption Rules` mechanically true.
- Boundary rules live in `.ai/architecture-rules.md → Module Resolution & Alias Rules`; this ADR records why the ancestor's pattern was reversed.
