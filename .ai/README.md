# AI Engineering Context

This directory defines the operational context for AI-assisted development inside this repository.

---

## Purpose

The `.ai/` directory standardizes AI-assisted development workflows: architectural decisions, implementation constraints, and context-loading strategy, so task execution stays deterministic and maintainable.

This layer exists to keep `CLAUDE.md` lean: `CLAUDE.md` stays a thin entrypoint, and the Claude Code mechanisms under `.claude/` (skills, rules, subagents, hook wiring) only reference these documents — they never restate them.

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
- **Backend work**: `.ai/backend-domain-boundaries.md` + the project's backend architecture doc (if present)
- **Frontend work**: `.ai/frontend-domain-boundaries.md` + the project's frontend architecture doc (if present)
- **Shared-package work (monorepo)**: `.ai/shared-domain-boundaries.md`
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
- `.ai/prompt-templates.md` owns prompt structure and context-loading patterns. Skill wrappers (`.claude/skills/*/SKILL.md`) only reference these templates by section; they don't restate them.
- `.ai/testing-patterns.md` owns verification selection and testing expectations. Side-specific patterns are split into `.ai/backend-testing-patterns.md` and `.ai/frontend-testing-patterns.md` so the path-scoped rules (`.claude/rules/*.md`) can load only the relevant one.
- `.ai/coding-standards.md` owns formatting, naming, implementation, and markdown conventions.
- `.ai/architecture-rules.md` and `.ai/domain-boundaries.md` own architectural invariants and boundary constraints. Side-specific and shared-package boundaries are split into `.ai/backend-domain-boundaries.md`, `.ai/frontend-domain-boundaries.md`, and `.ai/shared-domain-boundaries.md` for the same path-scoped loading reason.
- `.ai/implementation-patterns.md` owns reusable architectural structure and execution patterns.
- `planning/` owns bounded task plans, the task-plan template, and the archive lifecycle — see `planning/README.md`.
- `docs/` owns architecture reasoning and reference documentation; `docs/decisions/` owns ADRs — settled decisions are read from there, not re-litigated. `docs/06-repo-settings.md` owns the server-side repo settings the hooks assume.
- `.claude/hooks/` owns the implementation of enforced project policy (git guardrails, post-edit verification, PR body template enforcement, domain-boundary enforcement), wired through `.claude/settings.json`. Personal habits that aren't project policy use a `*.local.sh` suffix, are gitignored, and are wired through `.claude/settings.local.json` instead — see `CLAUDE.md → Claude Code Mechanisms`.

---

## Directory Structure

```txt
.ai/
├── README.md                     # AI context entrypoint
├── architecture-rules.md         # Architectural constraints and invariants
├── coding-standards.md           # Coding and formatting expectations
├── implementation-patterns.md    # Reusable implementation patterns
├── testing-patterns.md           # Shared testing principles and verification selection
├── backend-testing-patterns.md   # Backend-specific testing patterns
├── frontend-testing-patterns.md  # Frontend-specific testing patterns
├── domain-boundaries.md          # Boundary philosophy and repository-level ownership
├── backend-domain-boundaries.md  # Backend-specific ownership boundaries
├── frontend-domain-boundaries.md # Frontend-specific ownership boundaries
├── shared-domain-boundaries.md   # Shared-package ownership boundaries (monorepo)
├── task-workflow.md              # Task decomposition and execution workflow
└── prompt-templates.md           # Reusable prompt templates
```

Enforced policy scripts live in `.claude/hooks/` (see `CLAUDE.md → Claude Code Mechanisms`):

```txt
.claude/hooks/
├── guard-git.sh              # Blocks main-branch commits, force-push, staged secret/env files
├── guard-pr-body.sh          # Blocks PR creation unless the body follows .github/pull_request_template.md
├── guard-domain-boundary.sh  # Blocks implementer subagents from editing the other domain's files
└── post-edit-verify.sh       # Runs eslint after Write/Edit and surfaces results
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
