## Antigravity (AGY) / Gemini Operating Notes

This repo wires the following Antigravity mechanisms on top of the tool-agnostic guidance in `AGENTS.md` and `.ai/`. The actual logic and knowledge live in `.ai/`; everything under `.agents/` is a thin, Gemini-specific pointer to it. Keep it that way when adding more.

- **Hooks** (`.agents/hooks.json`): `PreToolUse` on `run_command` runs `.ai/hooks/guard-git.sh` — blocks commits on `main`/`master`, force-push, and staged secret/env files. `PreToolUse` on `run_command` also runs `.ai/hooks/guard-pr-body.sh` — blocks PR creation unless the body follows `.github/pull_request_template.md`. `PostToolUse` on `run_command` runs `.ai/hooks/suggest-branch-cleanup.sh` — after `git checkout main`, reminds (non-blocking) to check for mergeable local branches. `PostToolUse` on `mcp_.*pull_request_create` runs `.ai/hooks/remind-return-to-main.sh`.
- **Skills** (`.ai/skills/*/SKILL.md`): `implement`, `refactor`, `add-tests`, `update-docs`, `bugfix`, `start-task`, `execute-task` — each wraps the matching section of `.ai/prompt-templates.md`.
- **Rules** (`.ai/rules/*.md`): Contains domain-specific rules if you choose to implement them (e.g., path-scoped auto-loading for different parts of your project).
- **Subagents** (`.ai/agents/*.md`): Contains subagents for domain-specific implementation logic if needed.

