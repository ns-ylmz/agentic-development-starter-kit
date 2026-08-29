# Agentic Development Starter Kit

A **framework-agnostic**, **tech-stack-agnostic**, and **agent-agnostic** starter template for AI-assisted development (Agentic Coding).

## Why this exists

AI agents (like Claude Code, Cursor, Antigravity) are powerful, but they work best when they have clear boundaries, explicit architectures, and predictable workflows. This repository provides a baseline contract for agent-human collaboration. It answers:

- "Where should the AI look for rules?"
- "How should the AI structure tasks and git branches?"
- "How do we prevent the AI from making sweeping, unverified changes?"

This kit uses a hierarchical knowledge base (`.ai/`) and thin configuration wrappers (`.agents/`, `.claude/`) to ensure any tool can follow the exact same working agreement.

## Repository Structure

```txt
.ai/                      # The Single Source of Truth
├── README.md             # Entry point for agentic workflows
├── task-workflow.md      # Task lifecycle + agentic git collaboration workflow
├── architecture-rules.md # Architectural invariants
├── coding-standards.md   # Naming, styling, and markdown conventions
├── implementation-patterns.md
├── domain-boundaries.md  # Core vs Application boundary rules
├── testing-patterns.md   # Principles of verifiable behavior
└── prompt-templates.md   # Reusable Context/Task/Constraints prompt formats
.agents/                  # Antigravity (agy) specific hook/skill wiring
.claude/                  # Claude Code specific hook/skill wiring
.github/
├── pull_request_template.md      # Enforced by guard-pr-body.sh
└── workflows/ci.yml              # Generic CI validation placeholder
planning/                 # Bounded task plans: templates/task-plan.md, active/, archive/
docs/                     # Architecture doc skeletons (01-06 numbered)
```

## Getting Started

1. Drop this template into a new directory.
2. Initialize your tech stack (`npm init`, `cargo init`, `go mod init`, `python -m venv`, etc.).
3. Configure your testing and linting tools. (Optional: install `pre-commit` hooks via `pre-commit install`) Update `.github/workflows/ci.yml` accordingly.
4. Adapt `.ai/domain-boundaries.md` to your project's architecture.
5. If using an AI agent (like Antigravity / `agy`), point it to `AGENTS.md` or `.ai/README.md`.

## Key Mechanisms

- **Modularity**: Knowledge is split into small files (`coding-standards.md`, `architecture-rules.md`). Agents load only what they need.
- **Enforcement via Environment**: Instead of telling an LLM "don't commit to main", `.agents/hooks.json` points to bash scripts that strictly block invalid tool calls.
- **Task Focus**: Use `planning/` for explicit task scoping before implementation.
- **Agnostic**: Works for any language (Python, JS/TS, Go, Rust) and any architecture (Monolithic, Microservices).
