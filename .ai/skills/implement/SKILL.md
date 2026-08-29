---
name: implement
description: Use when starting an implementation task in this repo (backend, frontend, or shared package). Loads the standard context set and the Context/Task/Constraints/Affected Areas/Verification/Output prompt structure before implementing.
---

Follow `.ai/prompt-templates.md → Implementation Prompt` exactly:

1. Read the required files listed there (`.ai/task-workflow.md`, `.ai/architecture-rules.md`, `.ai/coding-standards.md`, plus the relevant architecture docs if the project has `docs/`).
2. Add the Optional files listed there only if the task crosses domain/service ownership — pick the `.ai/*-domain-boundaries.md` file matching the affected domain (backend/frontend/shared).
3. Apply the domain-specific constraint lines from the template that match the affected domain.
4. Structure the task using that template's Constraints, Affected Areas, Verification, and Output sections.


Do not restate the template here — `.ai/prompt-templates.md` is the single source of truth. If the template changes, this skill picks it up automatically on next read.
