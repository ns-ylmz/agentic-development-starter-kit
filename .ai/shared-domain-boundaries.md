# Shared Domain Boundaries

This document defines shared-package-specific ownership boundaries (`packages/shared` in the default monorepo layout). For boundary philosophy, repository-level ownership, and shared runtime contract rules that also apply here, see `.ai/domain-boundaries.md`.

Single-app projects: delete this file, or repoint it at the app's canonical shared-contracts module.

---

## Shared Contracts

The shared package owns:

- runtime-safe types and interfaces
- constants and const-based runtime contracts
- validation schemas shared across workspaces
- lifecycle, response, and error contracts consumed by both backend and frontend

Should NOT own:

- framework-specific logic (server framework decorators, React hooks/components)
- orchestration or business workflow logic
- persistence or transport implementation details
- environment-specific configuration

---

## Contract Stability

Changes to shared contracts affect every consumer. Prefer additive, backward-compatible changes. Treat breaking changes as cross-workspace tasks requiring coordinated backend and frontend updates — see `.ai/testing-patterns.md → Shared Package Testing` for verification expectations.

---

## Consumption Rules

Consumers import the shared package only through its public entrypoint as a declared workspace dependency — never via a path alias into its source tree, and never file-by-file into its internals. See `architecture-rules.md → Module Resolution & Alias Rules`.
