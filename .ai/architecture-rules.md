# Architecture Rules

This document defines the architectural invariants and implementation constraints that must remain stable as the project evolves. Treat these as long-term engineering constraints, not temporary implementation preferences. They are stack-agnostic; examples use TypeScript.

---

## Core Architectural Principles

Project principles are defined in `.ai/README.md → Long-Term Goal`. The rules below specify the invariants that preserve them.

---

## Domain Boundary Rules

Each domain owns its orchestration, transport, persistence, state, and testing. Domains must not depend on internal details of other domains — prefer shared runtime contracts and explicit interfaces.

For detailed domain ownership and boundary definitions, see `domain-boundaries.md`.

---

## Runtime Contract Rules

### Shared Contracts Must Remain Centralized

Runtime-safe shared contracts (constants, lifecycle contracts, response contracts, error contracts, shared runtime types) belong in one canonical place:

- monorepo: `packages/shared`
- single app: a dedicated `src/shared/contracts` (or equivalent) module

Do not duplicate runtime contracts across layers or workspaces.

### Preserve Serialization Safety

Shared contracts must remain serialization-safe, runtime-safe, and environment-agnostic. Avoid placing framework-specific logic inside shared contract modules.

---

## Module Resolution & Alias Rules

Path aliases are scoped per workspace:

- Each app/package defines its own TypeScript path aliases, and those aliases may only resolve into that workspace's own source.
- Never define or use an alias that resolves into another workspace's internals (e.g. an alias in `apps/frontend` pointing into `apps/backend/src`).
- Cross-workspace imports go exclusively through the shared package's public entrypoint, declared as a real workspace dependency (`import { X } from '@scope/shared'`), never through a path alias into another project's source tree.

This keeps every workspace independently buildable, testable, and extractable.

---

## Orchestration Rules

### Preserve Orchestration Layers

Business orchestration should remain isolated from:

- transport logic
- persistence implementation
- framework adapters
- infrastructure services

Examples:

- route guards should not contain orchestration logic
- HTTP client interceptors should not contain domain business rules
- infrastructure adapters should not coordinate workflows

### Prefer Explicit Lifecycle Coordination

Lifecycle behavior should remain observable, deterministic, testable, and centralized. Avoid hidden orchestration side effects.

---

## Service Layer Rules

Prefer narrowly scoped services (orchestration, utilities, infrastructure adapters, persistence). Avoid large multi-purpose services.

For service extraction guidance, see `implementation-patterns.md → Service Extraction Pattern`.

---

## Frontend Architecture Rules

- Orchestration, transport, server state, and presentation must remain separated.
- State coordination must remain explicit: pick one library per state category (see `.ai/frontend-domain-boundaries.md`) and don't mix their responsibilities.
- Avoid mixing orchestration behavior into UI components.

---

## Backend Architecture Rules

- Backend modules must remain isolated, testable, and orchestration-focused.
- Infrastructure integrations (mail, tokens, config, persistence) must remain behind service boundaries and support replacement without restructuring orchestration.

---

## Testing Rules

Changes affecting orchestration behavior, runtime contracts, lifecycle coordination, or shared infrastructure must include relevant test coverage, verification updates, and documentation synchronization.

For test layer responsibilities and verification selection, see `.ai/testing-patterns.md`.

---

## Anti-Patterns

Avoid:

- duplicating runtime contracts across layers or workspaces
- embedding orchestration into UI components or controllers
- coupling one domain directly to another domain's implementation details
- aliasing into another workspace's source tree
- mixing transport and orchestration behavior
- placing infrastructure logic inside orchestration services
- creating hidden cross-domain dependencies
- speculative abstraction before a second concrete use case exists

---

## AI Collaboration Rules

For AI implementation behavior rules, see `coding-standards.md → AI Implementation Rules`.
