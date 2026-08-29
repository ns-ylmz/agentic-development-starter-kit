---
name: execute-task
description: Use when asked to execute a specific bounded task plan file (e.g. planning/tasks/*.md) in this repo. Treats the task file as authoritative for scope, constraints, verification, and Git workflow.
---

Follow `.ai/prompt-templates.md → Task-File Execution Prompts` exactly.

Use the **Compact Task Execution Prompt** for routine execution. Use the **Controlled Task Execution Prompt** instead when dependency checks or Git workflow completion need extra emphasis (e.g. the task has explicit prerequisites, or past sessions have skipped verification/PR steps).

In both cases:

1. Follow `.ai/task-workflow.md` (AGENTS.md is already in context).
2. Treat the task file as authoritative for scope, constraints, affected areas, verification, and completion criteria. Keep changes strictly bounded to it — no scope expansion, no unrelated refactors.
3. Run all verification the task requires.
4. For branching, committing, and PR creation, follow `.ai/task-workflow.md → Agentic Git Collaboration Workflow`. When creating a PR, read `.github/pull_request_template.md` and use its exact structure.
5. Report the changed files and verification results.

Do not restate the template here — `.ai/prompt-templates.md` is the single source of truth.
