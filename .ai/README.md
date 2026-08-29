# AI Engineering Context

This directory defines the operational context for AI-assisted development inside this repository.

---

## Purpose

The `.ai/` directory standardizes AI-assisted development workflows: architectural decisions, implementation constraints, and context-loading strategy, so task execution stays deterministic and maintainable.

This layer exists to keep `AGENTS.md` lean: `AGENTS.md` stays a thin entrypoint, and the Agent mechanisms under `.agents/` (skills, rules, subagents, hook wiring) only reference these documents — they never restate them.

---

## Relationship to Other Documentation

### `README.md`

Use for: project overview, onboarding, quickstart, documentation navigation.

### `docs/` (if the project has one)

Use for: architecture reasoning, runtime behavior, security and lifecycle documentation, repository structure references.

### `.ai/`

Use for: implementation workflow, task execution rules, coding constraints, testing expectations, AI collaboration patterns, operational instructions.

---

## Context Loading Strategy

Agents should avoid loading unnecessary context. Use the smallest relevant context set for the current task.

- **Architectural or cross-domain decisions**: `README.md` + `.ai/architecture-rules.md` + `.ai/domain-boundaries.md`
- **Testing**: `.ai/testing-patterns.md` + the side-specific testing file
- **Tooling/config**: the changed tool's own config plus `.ai/coding-standards.md → Module Format Rules`

---

## Documentation Responsibilities

Agents must update documentation when changing:

- architectural boundaries
- runtime contracts
- workflow conventions
- repository structure
- testing strategy

The repository treats documentation as part of the engineering surface.

---

## Guidance Ownership

Keep reusable workflow guidance in its canonical layer. Avoid duplicating the same rule across layers — when a document needs guidance owned elsewhere, reference the canonical document instead of restating it.

- `.ai/task-workflow.md` owns task lifecycle, decomposition, workflow boundaries, escalation, and review discipline.
- `.ai/prompt-templates.md` owns prompt structure and context-loading patterns. Skill wrappers (`.agents/skills/*/SKILL.md`) only reference these templates by section; they don't restate them.
- `.ai/coding-standards.md` owns formatting, naming, implementation, and markdown conventions.
- `.ai/implementation-patterns.md` owns reusable architectural structure and execution patterns.
- `planning/` owns bounded task plans, the task-plan template, and the archive lifecycle — see `planning/README.md`.
- `docs/` owns architecture reasoning and reference documentation; `docs/decisions/` owns ADRs — settled decisions are read from there, not re-litigated. `docs/06-repo-settings.md` owns the server-side repo settings the hooks assume.
- `.ai/hooks/` owns the implementation of enforced project policy (git guardrails, post-edit verification, PR body template enforcement, domain-boundary enforcement), wired through `.agents/hooks.json`. Personal habits that aren't project policy use a `*.local.sh` suffix, are gitignored, and are wired through `.agents/hooks.local.json` instead — see `AGENTS.md → Agent Mechanisms`.

---

## Directory Structure

```txt
.ai/
├── README.md                     # AI context entrypoint
├── architecture-rules.md         # Architectural constraints and invariants
├── coding-standards.md           # Coding and formatting expectations
├── implementation-patterns.md    # Reusable implementation patterns
├── testing-patterns.md           # Shared testing principles and verification selection
├── domain-boundaries.md          # Boundary philosophy and repository-level ownership
├── task-workflow.md              # Task decomposition and execution workflow
└── prompt-templates.md           # Reusable prompt templates
```

Enforced policy scripts live in `.ai/hooks/` (see `AGENTS.md → Agent Mechanisms`):

```txt
.ai/hooks/
├── guard-git.sh              # Blocks main-branch commits, force-push, staged secret/env files
├── guard-pr-body.sh          # Blocks PR creation unless the body follows .github/pull_request_template.md
```

---

## Long-Term Goal

The goal is not to maximize AI-generated code.

The goal is to build a stable engineering workflow where:

- architecture remains coherent
- runtime behavior stays deterministic
- implementation drift is minimized
- AI agents can collaborate safely within bounded contexts
- the codebase remains sustainable over time
