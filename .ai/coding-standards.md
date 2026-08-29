# Coding Standards

This document defines coding expectations for AI-assisted implementation inside this repository: consistent, predictable, minimally abstracted code aligned with the project architecture. The principles apply to any stack.

---

## Core Principles

Code should be: explicit, readable, deterministic, testable, convention-driven, and minimally abstracted.

Prefer clarity over cleverness.

---

## General Rules

Agents should:

- inspect neighboring files before writing new code
- follow existing naming and folder conventions
- avoid unrelated formatting changes
- avoid broad rewrites during scoped tasks
- keep changes logically grouped
- prefer existing utilities and contracts
- avoid duplicating shared runtime values

---

## Naming Rules

Use names that describe responsibility, not implementation detail.

Prefer:

```txt
EmailVerificationService
AuthTokenService
refreshSessions
sessionTermination
```

Avoid:

```txt
Helper
Manager
Util
DataHandler
Thing
```

Generic suffixes are acceptable only when the surrounding domain makes responsibility obvious.

---

## File Naming Conventions

Inspect neighboring files before introducing a filename. Preserve the established local convention. Handle naming migrations as separate bounded refactors, and do not rename existing files opportunistically.

Default patterns (adjust per project, then keep this table synchronized):

| File responsibility                                 | Naming convention                                           | Examples                                       |
| --------------------------------------------------- | ----------------------------------------------------------- | ---------------------------------------------- |
| UI components and views                             | `PascalCase` with extension                                 | `DetailView.tsx`, `ToastProvider.swift`        |
| Logic hooks or composables                          | `camelCase` or language convention                          | `useAuthMutations.ts`, `auth_hooks.py`         |
| Backend source files                                | `kebab-case` or `snake_case` per language                   | `auth_token_service.py`, `users_controller.go` |
| Schemas and DTOs                                    | noun-based with responsibility suffix                       | `user.schema.ts`, `login_dto.rs`               |
| Shared contract files                               | descriptive with role suffix                                | `auth_response_types.py`                       |
| Unit tests                                          | source naming plus test suffix                              | `users_service_test.go`, `DetailView.test.tsx` |
| Integration tests                                   | domain and capability                                       | `users_create_integration_test.py`             |
| Markdown docs                                       | `kebab-case.md`; preserve numeric prefixes                  | `10-platform-architecture.md`                  |
| Config files                                        | ecosystem-required names                                    | `Makefile`, `pytest.ini`, `Cargo.toml`         |

---

## Module Format Rules

Prefer ESM for shared/root tooling where possible. CJS is allowed only when required by tooling compatibility.

Do not change module formats unless the change is explicitly part of the task.

---

## Typing Rules

Prefer:

- explicit domain types
- inferred local implementation types
- shared runtime contracts from the canonical shared module (see `architecture-rules.md → Runtime Contract Rules`)
- narrow function inputs
- clear return shapes for exported functions
- workspace-scoped path aliases only (see `architecture-rules.md → Module Resolution & Alias Rules`)

Avoid:

- unnecessary `any`
- duplicated DTO or contract shapes
- framework-specific types in shared modules
- over-wide union types without clear purpose
- aliases that resolve into another workspace's source

When creating shared values, prefer const-based runtime contracts over language-specific enums that lack runtime representation.

---

## Formatting & Linting

Formatting and linting are handled by project-specific tools (e.g., Prettier, ESLint, Ruff, gofmt, Black). Agents should follow the project tooling and never debate style covered by them.

---

## Testing Code Standards

Follow the conventions of nearby test files. See `.ai/testing-patterns.md`.

---

## Documentation Standards

When code changes affect architecture or workflow, update the relevant documentation layer:

```txt
README.md   → orientation and navigation
docs/       → architecture, runtime behavior, reference documentation
.ai/        → AI workflow and operational implementation guidance
```

Avoid putting implementation-heavy detail back into README.

---

## Refactoring Rules

Refactors should be: scoped, intentional, verifiable, and isolated from unrelated feature work.

Avoid:

- speculative abstraction
- broad rewrites
- style-only churn in unrelated files
- changing public contracts without explicit need

For when and how to extract services, see `.ai/implementation-patterns.md → Service Extraction Pattern`.

---

## Markdown Formatting Standards

- use `---` only before top-level `##` sections
- do not use separators before `###` subsections
- use fenced code blocks for all multiline examples
- use backticks for file paths, commands, modules, and config names
- keep bullet indentation consistent
- preserve existing document formatting patterns

Before modifying documentation, inspect nearby formatting patterns and preserve section hierarchy and spacing.

---

## AI Implementation Rules

AI agents should:

- prefer existing patterns over new ones
- explain uncertainty before broad changes
- avoid guessing architectural intent
- keep generated code minimal and reviewable
- preserve deterministic behavior
- surface required follow-up work explicitly
