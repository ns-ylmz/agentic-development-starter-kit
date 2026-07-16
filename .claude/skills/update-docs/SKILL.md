---
name: update-docs
description: Use when a change needs accompanying documentation updates in this repo (README.md, docs/, or .ai/). Enforces the existing documentation layering instead of dumping everything into one file.
---

Follow `.ai/prompt-templates.md → Documentation Prompt` exactly:

1. Read README.md and the relevant `docs/*` and `.ai/*` files for the area being documented.
2. Keep README.md concise; place implementation reasoning inside `docs/`; place operational workflow guidance inside `.ai/`.
3. Preserve existing documentation layering and formatting conventions (see `.ai/README.md → Relationship to Other Documentation` and `.ai/README.md → Guidance Ownership`).

Do not restate the template here — `.ai/prompt-templates.md` is the single source of truth.
