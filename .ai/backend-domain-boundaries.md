# Backend Domain Boundaries

This document defines backend-specific ownership boundaries. For boundary philosophy, repository-level ownership, and shared runtime contract rules that also apply to the backend, see `.ai/domain-boundaries.md`.

The layer names below are framework-agnostic (they map naturally to NestJS, Express, Fastify, etc.). Extend this file with project-specific module ownership as the backend grows.

---

## Backend Modules

Backend modules own:

- orchestration services
- persistence coordination
- DTO validation
- authorization boundaries
- infrastructure integration

Modules should remain isolated and testable.

---

## Orchestration Services

Own: lifecycle coordination, workflow orchestration, domain-level runtime behavior.

Should NOT own: direct transport handling, infrastructure implementation details, unrelated domain behavior.

Examples: authentication orchestration, verification lifecycle coordination, session lifecycle management.

---

## Infrastructure Services

Own: infrastructure adapters, external integrations, transport implementation details.

Examples: mail delivery, token signing, encryption utilities, database adapters.

Should remain replaceable without restructuring orchestration logic.

---

## Controllers / Route Handlers

Own: request handling, transport boundaries, DTO binding, response serialization.

Should NOT own: orchestration logic, business workflows, persistence coordination.

---

## Guards & Strategies / Middleware

Own: authentication validation, authorization checks, request-level access control.

Should NOT own: workflow orchestration, persistence behavior, runtime coordination logic.
