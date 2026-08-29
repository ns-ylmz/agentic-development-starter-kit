# Agentic Development Starter Kit

A framework-agnostic, tech-stack-agnostic, and agent-agnostic starter kit for building projects with Agentic AI.

## Philosophy

This template shifts from "putting all rules in the LLM context" to "distributing rules into the environment and modular structures". By relying on the environment and targeted contexts, it improves **Context Loading** (better LLM focus) and **Cost Management** (fewer tokens used).

## Directory Structure

```txt
.agents/                  # Agent-specific tool hooks and configurations (e.g. Antigravity)
.ai/                      # The canonical knowledge layer: rules, standards, patterns
  ├── README.md           # Entrypoint for agents to understand context loading
  ├── skills/             # On-demand, specialized agent workflows
  ├── rules/              # Path-scoped, conditionally loaded rules
  ├── agents/             # Subagents with isolated contexts
  └── hooks/              # Bash scripts for policy enforcement (e.g., git guardrails)
planning/                 # Bounded task plans (template + active/archive lifecycle)
docs/                     # Architecture documentation and ADRs
.github/                  # Agnostic CI and PR templates
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
