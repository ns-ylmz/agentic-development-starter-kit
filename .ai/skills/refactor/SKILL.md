---
name: refactor
description: Use when the task is a refactor rather than new behavior (improving boundary clarity, reducing duplication) in this repo. Loads architecture context and keeps the change behavior-preserving.
---

Follow `.ai/guidelines/prompt-templates.md → Refactor Prompt` exactly:

1. Read `.ai/guidelines/architecture.md`, `.ai/guidelines/standards.md`, and the relevant architecture docs for the target area.
2. Keep the goals scoped to boundary clarity, duplication reduction, and preserving deterministic behavior.
3. Do not change public runtime contracts or perform broad rewrites; preserve testing conventions.
4. Verify with scoped tests confirming behavior is unchanged.

Do not restate the template here — `.ai/guidelines/prompt-templates.md` is the single source of truth.
