# Testing Patterns

This document defines testing expectations, validation scope, and verification behavior, to keep tests deterministic and behavior-focused rather than implementation-coupled. Testing is treated as part of the engineering surface, not secondary implementation validation.

---

## Core Testing Principles

The project prioritizes:

- observable behavior testing
- orchestration-aware validation
- deterministic lifecycle verification
- isolated responsibility testing
- explicit verification boundaries

Avoid tests tightly coupled to implementation details.

---

## Verification Philosophy

Verification should remain proportional to implementation scope.

Prefer:

```txt
small scoped verification
→ before full repository validation
```

Examples (monorepo):

```bash
npm run test --workspace backend
npm run lint --workspace frontend
```

Use repository-wide verification only when changes affect:

- shared contracts
- tooling
- cross-domain orchestration
- repository-wide runtime behavior

---

## Verification Selection

Choose verification by affected area and risk. Prefer the smallest deterministic verification set that proves the task outcome.

- **Documentation-only tasks**: command-based formatting checks (`git diff --check`, `npx prettier --check`) plus manual boundary checks.
- **Tooling tasks**: verify the changed tool or script directly before broad repository verification.
- **Frontend tasks**: smallest relevant frontend test, lint, or typecheck command covering the affected area.
- **Backend tasks**: smallest relevant backend unit or integration test command covering the affected orchestration or service behavior.
- **Shared contract tasks**: verify shared package behavior, then run the smallest frontend and backend checks needed to confirm consumers remain synchronized.
- **Cross-workspace tasks**: list each affected workspace and run verification for each changed boundary.

Manual checks should confirm:

- changed files match the task scope
- no production code changed when the task is documentation-only
- no runtime contracts changed unless explicitly in scope
- markdown formatting follows `.ai/coding-standards.md`

Avoid over-verification when an isolated task has a deterministic smaller check. Avoid under-verification when a change crosses runtime contracts, orchestration layers, or workspace boundaries.

---

## Backend and Frontend Testing Patterns

Side-specific testing patterns live in dedicated files so agents load only the one relevant to the task:

- `.ai/backend-testing-patterns.md`
- `.ai/frontend-testing-patterns.md`

The sections above apply to both.

---

## Shared Package Testing

Shared package tests should validate:

- runtime-safe contracts
- serialization safety
- constant consistency
- lifecycle contract stability

Default placement:

```txt
packages/shared/test/
```

---

## Testing Anti-Patterns

Avoid:

- testing implementation details directly
- asserting internal framework behavior
- broad snapshot overuse
- duplicating orchestration tests across layers
- coupling tests to unstable implementation structure
- bypassing runtime contracts in tests

---

## AI Verification Expectations

For AI implementation behavior rules and verification expectations, see `coding-standards.md → AI Implementation Rules`.
