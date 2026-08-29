# Planning

This directory owns task plans and their lifecycle. `.ai/guidelines/workflow.md → Task Decomposition Standards` defines what a bounded task is; this directory is where those tasks live as files, so execution is repeatable and reviewable.

---

## Structure

```txt
planning/
├── README.md        # This file - planning conventions and archive lifecycle
├── templates/
│   └── task-plan.md # Copy this to start a new bounded task plan
├── active/          # Task plans currently being executed (group by phase/initiative as needed)
└── archive/         # Completed or superseded plans, kept for traceability
```

Group active plans however the project needs (e.g. `active/phase-1/tasks/`, `active/<initiative>/`). Keep the grouping shallow and consistent.

---

## Task Plan Lifecycle

1. Copy `templates/task-plan.md` into `active/` and fill every section. A plan is ready for execution when its scope can be verified before implementation starts (see `.ai/guidelines/workflow.md → Task Decomposition Standards`).
2. Execute it with the `execute-task` skill (or the Task-File Execution Prompts in `.ai/guidelines/prompt-templates.md`). The task file is authoritative for scope, constraints, verification, and completion criteria.
3. When the task's PR is merged (or the plan is superseded), move the file to `archive/` in the same change that closes it out, or delete it if it holds no lasting decision value. Every completed plan gets an explicit archive-or-delete disposition — don't let `active/` accumulate finished work.

---

## Conventions

- One file per bounded task, named `kebab-case.md` after the task's primary outcome.
- Planning-only commits use the `planning:` Conventional Commit type.
- Plans reference documentation by path (e.g. `.ai/guidelines/architecture.md → Runtime Contract Rules`) rather than restating rules.
