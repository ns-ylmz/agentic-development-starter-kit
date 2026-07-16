# Backend Testing Patterns

This document defines backend-specific testing expectations. For core testing principles, verification philosophy/selection, shared package testing, and testing anti-patterns that also apply to the backend, see `.ai/testing-patterns.md`.

---

## Unit Tests

Backend unit tests should validate:

- isolated service behavior
- utility logic
- deterministic transformations
- orchestration decisions

Prefer colocated unit tests:

```txt
src/**/__tests__/
```

Examples: token hashing behavior, cooldown validation, session pruning behavior.

---

## Integration Tests

Integration tests should validate:

- orchestration coordination
- persistence behavior
- infrastructure integration
- runtime interaction correctness

Default placement (adjust per project, then keep this synchronized):

```txt
test/integration/<domain>/<domain>.<capability>.int-spec.ts
```

Examples: authentication flows, refresh rotation, password reset behavior.

---

## Backend Verification Rules

When modifying:

| Area                       | Expected Verification                   |
| -------------------------- | --------------------------------------- |
| service logic              | relevant unit tests                     |
| orchestration flows        | integration tests                       |
| runtime contracts          | shared package tests                    |
| infrastructure integration | integration tests + runtime validation  |
