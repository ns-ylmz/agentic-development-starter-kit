# AI Engineering Context

This directory defines the operational context for AI-assisted development inside this repository.

---

## Purpose

The `.ai/` directory standardizes AI-assisted development workflows: architectural decisions, implementation constraints, and context-loading strategy, so task execution stays deterministic and maintainable.

This layer exists to keep `AGENTS.md` lean: `AGENTS.md` stays a thin entrypoint, and the Agent mechanisms under `.agents/` and `.claude/` (skills, rules, subagents, hook wiring) only reference these documents — they never restate them.

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

- **Architectural or cross-domain decisions**: `README.md` + `.ai/guidelines/architecture.md`
- **Testing and Coding Rules**: `.ai/guidelines/standards.md`
- **Workflow and Planning**: `.ai/guidelines/workflow.md`

---

## Guidance Ownership

Keep reusable workflow guidance in its canonical layer. Avoid duplicating the same rule across layers.

- `.ai/guidelines/workflow.md` owns task lifecycle, decomposition, workflow boundaries, and review discipline.
- `.ai/guidelines/prompt-templates.md` owns prompt structure and context-loading patterns. Skill wrappers only reference these templates by section.
- `.ai/guidelines/standards.md` owns formatting, naming, testing patterns, and implementation expectations.
- `.ai/guidelines/architecture.md` owns domain boundaries, reusable capabilities, and architectural invariants.
- `planning/` owns bounded task plans, the task-plan template, and the archive lifecycle.
- `.ai/hooks/` owns the implementation of enforced project policy (git guardrails, PR body template enforcement).

---

## Directory Structure

```txt
.ai/
├── README.md                     # AI context entrypoint
├── guidelines/
│   ├── architecture.md           # Architectural constraints, boundaries, and patterns
│   ├── standards.md              # Coding, formatting, and testing expectations
│   ├── workflow.md               # Task decomposition and execution workflow
│   └── prompt-templates.md       # Reusable prompt templates
├── hooks/
│   ├── guard-git.sh              # Blocks main-branch commits, force-push, staged secret/env files
│   └── guard-pr-body.sh          # Blocks PR creation unless the body follows pull_request_template.md
├── rules/                        # Domain-specific rules and auto-loading (if applicable)
├── skills/                       # Agnostic instruction files for standard tasks (e.g. start-task, implement)
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
