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

Projects should establish clear boundaries between different conceptual layers. When adapting this template to your project, define the boundaries that make sense for your architecture (e.g., core domain vs infrastructure, or client vs server).

### Application Layer

The application layer owns runtime orchestration. It coordinates runtime behavior but should avoid housing core business rules or duplicated contracts.

### Core / Shared Layer

The core layer owns reusable capabilities, business logic, and shared contracts. It should remain environment-agnostic and orchestration-independent.

### Isolation

Layers should avoid reaching into each other's internals:

- No circular dependencies between layers.
- Interaction between boundaries must happen through explicitly defined public entrypoints (e.g., interfaces, facades, or API boundaries).

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
- embedding orchestration into UI or infrastructure components
- bypassing explicit layer interfaces
- creating hidden cross-domain dependencies
