---
name: bugfix
description: Use when fixing a reported bug in this repo. Forces root-cause identification and reproduction before and after the fix, instead of jumping straight to a patch.
---

Follow `.ai/guidelines/prompt-templates.md → Bugfix Prompt` exactly:

1. Read the relevant architecture docs, and the relevant workflow docs for the affected area.
2. Identify the root cause before implementing a fix.
3. Reproduce the issue before the fix and verify it's resolved after.
4. Preserve existing orchestration behavior; avoid unrelated refactors; minimize implementation scope.
5. Run the relevant verification commands.

Do not restate the template here — `.ai/guidelines/prompt-templates.md` is the single source of truth.
