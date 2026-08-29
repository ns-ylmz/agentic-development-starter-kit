---
name: add-tests
description: Use when adding or updating tests for existing behavior in this repo. Loads testing-pattern context and enforces validating observable behavior over implementation details.
---

Follow `.ai/guidelines/prompt-templates.md → Testing Prompt` exactly:

1. Read the required files listed there (`.ai/guidelines/standards.md`).
2. Inspect nearby tests before implementing new ones.
3. Validate observable behavior; avoid implementation-detail assertions. Preserve existing testing conventions.
4. Run the relevant test suites as verification.

Do not restate the template here — `.ai/guidelines/prompt-templates.md` is the single source of truth.
