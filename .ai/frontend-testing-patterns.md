# Frontend Testing Patterns

This document defines frontend-specific testing expectations. For core testing principles, verification philosophy/selection, shared package testing, and testing anti-patterns that also apply to the frontend, see `.ai/testing-patterns.md`.

---

## Frontend Test Focus

Frontend tests should validate:

- observable UI behavior
- orchestration coordination
- lifecycle synchronization
- route behavior
- state transitions

Avoid testing implementation details directly.

---

## Frontend Test Structure

Frontend tests mirror the application structure — colocate tests with the feature or component they validate, following the nearby convention.

---

## Frontend Verification Areas

Frontend validation should prioritize:

- bootstrap coordination
- session/auth orchestration
- route guards
- lifecycle coordination
- transport coordination
- mutation state handling

---

## Frontend Mocking Rules

Prefer mocking:

- transport boundaries
- external integrations
- unstable infrastructure behavior

Avoid mocking:

- orchestration state
- lifecycle coordination
- route behavior
- shared runtime contracts
