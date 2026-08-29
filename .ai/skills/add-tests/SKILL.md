---
name: add-tests
description: Use when adding or updating tests for existing behavior in this repo. Loads testing-pattern context and enforces validating observable behavior over implementation details.
---

Follow `.ai/prompt-templates.md → Testing Prompt` exactly:

1. Read the required files listed there (`.ai/testing-patterns.md`).
2. Add the Optional file listed there matching the target area (`.ai/backend-testing-patterns.md` or `.ai/frontend-testing-patterns.md`).
3. Inspect nearby tests before implementing new ones.
4. Validate observable behavior; avoid implementation-detail assertions. Preserve existing testing conventions.
5. Run the relevant test suites as verification.

Do not restate the template here — `.ai/prompt-templates.md` is the single source of truth.
