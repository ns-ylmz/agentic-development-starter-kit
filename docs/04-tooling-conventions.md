# Tooling Conventions

The reasoning behind the tooling setup in this template. The rules agents follow live in `.ai/guidelines/standards.md`; this document records the philosophy.

## Tech-Stack Agnostic

This template contains no assumptions about the package manager, language, or framework. It does not ship a `package.json`, `requirements.txt`, `go.mod`, or any language-specific configuration. 

When you adopt this template, you should configure your tooling based on these principles:

## Lint & Format

Formatting and linting should be automated and non-debatable. Choose tools that fit your ecosystem (e.g., Prettier + ESLint for TS, Ruff for Python, gofmt for Go).

Enforcement should run at two levels:

| Level          | Mechanism                                            | Bypassable                       |
| -------------- | ---------------------------------------------------- | -------------------------------- |
| At commit time | `pre-commit` framework (`.pre-commit-config.yaml`)   | Yes (`--no-verify`)              |
| On every PR    | `.github/workflows/ci.yml`                           | No — the enforcement that counts |

## Module Formats and Types

Set up your module resolution to avoid cross-module aliasing. Each module should be independently buildable and testable.

## Commit Conventions

Use Conventional Commits. The list of approved types is defined in `.ai/guidelines/workflow.md → Agentic Git Collaboration Workflow`. If you configure a tool like `commitlint`, ensure the two lists remain synchronized.
