# Implementation Patterns

This document defines preferred implementation patterns to keep implementation and orchestration behavior consistent and predictable. Treat these as preferred approaches, not rigid framework constraints. They are framework-agnostic; adjust the concrete directory shapes to the project's stack.

---

## Core Philosophy

Project principles are defined in `.ai/README.md → Long-Term Goal`.

Prefer predictable implementation over implicit framework magic.

---

## Service Extraction Pattern

Extract services when:

- orchestration logic becomes reusable
- responsibilities become mixed
- infrastructure concerns need isolation
- lifecycle coordination grows independently

Example split:

```txt
AuthService              → orchestration coordination
EmailVerificationService → verification lifecycle behavior
AuthTokenService         → token generation and hashing behavior
```

Avoid premature extraction for trivial logic.

---

## Orchestration Pattern

Keep orchestration centralized.

Preferred structure:

```txt
transport layer
→ orchestration layer
→ infrastructure/persistence layer
```

Avoid transport handlers (controllers, route handlers) coordinating infrastructure directly.

---

## Shared Runtime Contract Pattern

For runtime contract rules and shared module conventions, see `architecture-rules.md → Runtime Contract Rules`.

---

## Frontend Feature Pattern

Frontend features should remain domain-oriented.

Preferred structure:

```txt
features/
└── <feature>/
    ├── components/
    ├── constants/
    ├── hooks/
    ├── services/
    ├── store/
    └── types/
```

Features own their orchestration behavior, feature-specific state, and runtime coordination. Avoid leaking orchestration across unrelated features.

---

## API Layer Pattern

API/transport layers should remain transport-focused: request configuration, interceptors, token attachment, retry coordination, serialization.

Avoid orchestration decisions, UI behavior, or lifecycle ownership in the transport layer.

---

## Backend Module Pattern

Backend modules should remain isolated and domain-oriented.

Preferred structure:

```txt
<module>/
├── dto/
├── guards/
├── services/
├── types/
├── __tests__/
├── <module>.controller.ts
├── <module>.module.ts
└── <module>.service.ts
```

Modules own their orchestration, DTO validation, persistence coordination, and runtime lifecycle behavior.

---

## Infrastructure Isolation Pattern

For infrastructure isolation rules, see `architecture-rules.md → Backend Architecture Rules`.

---

## Verification Pattern

For verification philosophy and proportional testing guidance, see `testing-patterns.md → Verification Philosophy`.

---

## Refactoring Pattern

For refactoring discipline, see `coding-standards.md → Refactoring Rules`.

---

## AI Collaboration Pattern

For AI implementation behavior rules, see `coding-standards.md → AI Implementation Rules`.
