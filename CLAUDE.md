@AGENTS.md

## Claude Code Operating Notes

This repo wires the following Claude Code mechanisms on top of the tool-agnostic guidance in `AGENTS.md` and `.ai/`. The actual logic and knowledge live in `.ai/`; everything under `.claude/` is a thin, Claude-specific pointer to it. Keep it that way when adding more.

- **Hooks** (`.claude/settings.json` → `.ai/hooks/*.sh`): `PreToolUse` on `Bash` runs `guard-git.sh` — blocks commits on `main`/`master`, force-push, and staged secret/env files. `PreToolUse` on `Bash` also runs `guard-pr-body.sh` — blocks PR creation unless the body follows `.github/pull_request_template.md`.
- **Skills** (`.claude/skills/*/SKILL.md`): `implement`, `refactor`, `add-tests`, `update-docs`, `bugfix`, `start-task`, `execute-task` — each wraps the matching section of `.ai/prompt-templates.md`. 
- **Rules** (`.claude/rules/*.md`): path-scoped auto-loading. Add your domain-specific rules here if needed.
- **Local overrides** (`.claude/settings.local.json`): gitignored and per-user, read alongside `.claude/settings.json` but taking precedence over it. It's the escape hatch for machine-specific settings that must not become project policy.
