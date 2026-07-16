# Frontend Domain Boundaries

This document defines frontend-specific ownership boundaries. For boundary philosophy, repository-level ownership, and shared runtime contract rules that also apply to the frontend, see `.ai/domain-boundaries.md`.

The layer names below are framework-agnostic. Fill in the project's concrete library choices in the State sections and keep them synchronized once decided.

---

## Frontend Features

Frontend features own:

- domain-level orchestration
- feature-specific state
- feature hooks
- feature runtime coordination

Features should remain isolated from unrelated orchestration behavior.

---

## Transport Layer

Owns: HTTP clients, interceptors, request coordination, transport-level retry behavior.

Should NOT own: UI behavior, presentation logic, domain orchestration rules.

---

## Orchestration Layer

Owns: lifecycle coordination, bootstrap behavior, session synchronization, route coordination, orchestration state transitions.

Should remain explicit and centralized.

---

## UI Components

Own: rendering, presentation, local interaction behavior.

Should NOT own: orchestration logic, transport coordination, runtime synchronization.

---

## Server State

Server state coordination belongs to one dedicated library (project choice, e.g. TanStack Query):

```txt
<server-state library>
```

Responsibilities: caching, server synchronization, async request coordination.

---

## Orchestration State

Orchestration state belongs to one dedicated library (project choice, e.g. Redux Toolkit or Zustand):

```txt
<orchestration-state library>
```

Responsibilities: lifecycle state, bootstrap status, orchestration coordination, session termination state.

Avoid mixing orchestration state and server state responsibilities — one category of state never lives in the other's library.
