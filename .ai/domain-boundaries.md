# Domain Boundaries

This document defines ownership boundaries and responsibility separation, to prevent cross-layer coupling and orchestration leakage. These boundaries are intended to remain valid as the project evolves.

---

## Boundary Philosophy

Each layer should have:

- explicit ownership
- isolated responsibilities
- deterministic interaction surfaces
- stable runtime contracts

Layers should collaborate through orchestration, shared runtime contracts, and explicit interfaces. Avoid hidden cross-layer dependencies.

---

## Repository-Level Boundaries

Default monorepo layout (adjust to the project's actual structure; single-app projects keep only the relevant parts):

### `apps/`

Application workspaces own runtime orchestration (e.g. backend API, frontend web application). Applications coordinate runtime behavior but should avoid duplicating shared contracts.

### `packages/`

Packages own reusable cross-workspace capabilities (runtime-safe shared contracts, shared UI components). Packages should remain reusable, environment-agnostic, and orchestration-independent.

### Workspace Isolation

Workspaces never reach into each other's internals:

- no imports from another workspace's `src/`
- no path aliases resolving into another workspace (see `architecture-rules.md → Module Resolution & Alias Rules`)
- cross-workspace collaboration goes only through a shared package's public entrypoint, declared as a workspace dependency

---

## Shared Runtime Contract Boundaries

Shared runtime contracts are centralized in the canonical shared module (`packages/shared` in a monorepo). For rules governing shared contracts, see `architecture-rules.md → Runtime Contract Rules`.

---

## Backend, Frontend, and Shared Domain Boundaries

Side-specific ownership boundaries live in dedicated files so agents load only the one relevant to the task:

- `.ai/backend-domain-boundaries.md`
- `.ai/frontend-domain-boundaries.md`
- `.ai/shared-domain-boundaries.md`

The sections above apply to all three.

---

## Testing Boundaries

For detailed testing patterns and verification guidance, see `testing-patterns.md`.

---

## Documentation Boundaries

For documentation standards, see `coding-standards.md → Documentation Standards`. For guidance ownership, see `.ai/README.md → Guidance Ownership`.

---

## Boundary Violation Anti-Patterns

Avoid:

- duplicating runtime contracts
- embedding orchestration into UI components
- coupling frontend directly to backend implementation details
- importing or aliasing across workspace boundaries
- mixing transport and orchestration behavior
- placing infrastructure logic inside orchestration services
- creating hidden cross-domain dependencies
- bypassing shared runtime contracts
