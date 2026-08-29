# Architecture Rules

This document defines the architectural invariants and implementation constraints that must remain stable as the project evolves. Treat these as long-term engineering constraints, not temporary implementation preferences. They are stack-agnostic.

---

## Architectural Invariants

- **Boundary Enforcement**: Components and layers must interact only through explicitly defined boundaries.
- **Contract Ownership**: Runtime contracts (e.g. schemas, types) must have a single source of truth.
- **Side-Effect Isolation**: Core business logic must be isolated from side effects, external integrations, and UI state.
- **Stateless Orchestration**: Orchestration services should coordinate rather than hold domain state.
- **Predictable Error Paths**: Every operation that can fail must have a deterministic error-handling path that bubbles up to a defined boundary.

---

## Runtime Contract Rules

A single source of truth governs the shape of data crossing boundaries.

Centralize shared contracts:
- schemas (e.g. Zod, Pydantic)
- type definitions
- validation logic
- shared constants (e.g. HTTP status codes, error codes, role definitions)

Do not duplicate runtime contracts across layers.

---

## Module Resolution & Alias Rules

Path aliases are scoped per project/module:

- Each module defines its own path aliases, and those aliases may only resolve into that module's own source.
- Never define or use an alias that resolves into another module's internals (e.g. an alias in a client application pointing directly into server source files).
- Cross-module imports go exclusively through public entrypoints (e.g., standard package imports), never through a path alias into another project's source tree.

This keeps every module independently buildable, testable, and extractable.

---

## Refactoring Constraints

- Keep refactoring separated from feature implementation whenever possible.
- Do not introduce abstractions for a single consumer.
- Do not generalize code unless there are at least two concrete use cases.
- Do not extract shared capabilities without verifying they do not leak orchestration logic.
- Do not rename or move files if the change breaks an existing runtime contract without fixing its consumers.

See `coding-standards.md → Refactoring Guidelines`.

---

## Anti-Patterns

Avoid:

- creating abstractions for a single consumer
- leaking orchestration or framework details into shared modules
- duplicating runtime contracts across layers
- aliasing into another module's source tree
- embedding complex branching in UI components
- mixing data fetching with data transformation
- silently swallowing errors at domain boundaries
