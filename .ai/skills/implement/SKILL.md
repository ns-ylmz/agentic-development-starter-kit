---
name: implement
description: Use when starting an implementation task in this repo. Loads the standard context set and the Context/Task/Constraints/Affected Areas/Verification/Output prompt structure before implementing.
---

Follow `.ai/guidelines/prompt-templates.md → Implementation Prompt` exactly:

1. Read the required files listed there (`.ai/guidelines/workflow.md`, `.ai/guidelines/architecture.md`, `.ai/guidelines/standards.md`, plus the relevant architecture docs if the project has `docs/`).
2. Structure the task using that template's Constraints, Affected Areas, Verification, and Output sections.

Do not restate the template here — `.ai/guidelines/prompt-templates.md` is the single source of truth. If the template changes, this skill picks it up automatically on next read.
