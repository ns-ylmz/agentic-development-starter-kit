# Standards

This document defines coding expectations and testing principles for AI-assisted implementation.

## General Coding Rules

Agents should:
- Inspect neighboring files before writing new code.
- Follow existing naming and folder conventions.
- Avoid broad rewrites during scoped tasks.
- Keep changes logically grouped.
- Prefer explicit domain types over `any` or loose types.
- Explain uncertainty before making broad architectural changes.

## File Naming Conventions

Inspect neighboring files before introducing a filename. Preserve the established local convention.

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

## Testing Patterns

Testing is treated as part of the engineering surface, not secondary implementation validation.

- **Observable Behavior**: Test observable behavior rather than internal implementation details or framework specifics.
- **Verification Selection**: Choose the smallest deterministic verification set (e.g., a unit test for a single function, an integration test for an endpoint). Use repository-wide verification only for shared contracts or cross-domain features.
- **Shared Packages**: Validate runtime-safe contracts, constant consistency, and serialization safety.

## Markdown & Documentation Standards

- Update relevant documentation when architecture or workflow changes.
- Avoid putting implementation-heavy detail back into the root `README.md`.
- Use fenced code blocks for all multiline examples.
- Use backticks for file paths, commands, modules, and config names.
