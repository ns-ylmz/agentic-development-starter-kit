# Architecture

This document defines the architectural invariants and ownership boundaries. Treat these as long-term engineering constraints.

## Core Architectural Invariants

- **Boundary Enforcement**: Components interact only through explicitly defined boundaries.
- **Contract Ownership**: Runtime contracts (schemas, types) have a single source of truth.
- **Side-Effect Isolation**: Core business logic is isolated from external integrations and UI.
- **Stateless Orchestration**: Orchestration services coordinate rather than hold domain state.

## Domain Boundaries

Each layer should have explicit ownership, isolated responsibilities, and stable runtime contracts.

- **Application / Presentation Layer**: Coordinates runtime behavior and UI. Do not house core business rules here.
- **Core / Shared Layer**: Reusable capabilities, business logic, and shared contracts. Must remain environment-agnostic.
- **Infrastructure Layer**: Persistence, third-party APIs, and external side-effects.

Interaction between layers must happen through explicitly defined public entrypoints (e.g., interfaces or API boundaries). No circular dependencies.

## Runtime Contract Rules

Centralize shared contracts:
- schemas (e.g. Zod, Pydantic, Structs)
- type definitions
- validation logic
- shared constants (e.g. HTTP status codes, error codes, role definitions)

Do not duplicate runtime contracts across layers.

## Module Resolution & Alias Rules

- Each module defines its own path aliases (if any).
- Cross-module imports go exclusively through public entrypoints (e.g. standard package imports), never through a path alias directly into another module's internals.

## Implementation & Orchestration Patterns

- **Service Extraction**: Extract services when logic becomes reusable, infrastructure concerns need isolation, or lifecycle coordination grows independently. Avoid premature extraction for trivial logic.
- **Orchestration**: Keep orchestration centralized. Preferred flow: `transport -> orchestration -> infrastructure`.
- **Features**: Features own their orchestration behavior, feature-specific state, and runtime coordination. Avoid leaking orchestration across unrelated features.
