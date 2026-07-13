# Claude Code Policy Starter Kit

Reusable Claude Code project-policy hooks, independent of any specific project. Drop the contents of this repo into a new project to get the same enforced guardrails.

## Layout

```
.ai/hooks/
├── guard-git.sh          # PreToolUse / Bash — blocks main/master commits, force-push, staged secrets
├── guard-pr-body.sh      # PreToolUse / pull_request_create — enforces .github/pull_request_template.md sections
└── post-edit-verify.sh   # PostToolUse / Write|Edit — surfaces eslint output for the touched file
.claude/settings.json     # Wires the 3 hooks above into Claude Code
.github/pull_request_template.md  # Starter PR template; guard-pr-body.sh reads its ## sections dynamically
```

## Using this in a new project

1. Copy `.ai/hooks/*.sh` into the target project's `.ai/hooks/` (create the folder if needed), then `chmod +x` them.
2. Copy `.claude/settings.json` into the target project — merge the `hooks` block if one already exists there.
3. Copy `.github/pull_request_template.md` into the target project, then edit its `##` sections to match that project's own conventions. `guard-pr-body.sh` reads whatever headers are present, so no script changes are needed.
4. `post-edit-verify.sh` no-ops harmlessly in projects without eslint.

## What each hook enforces

- **guard-git.sh**: no direct commits to `main`/`master`, no force-push, no committing files that look like secrets/env files.
- **guard-pr-body.sh**: PR body must contain every `##` section from the project's own PR template. No template file present → hook allows silently.
- **post-edit-verify.sh**: runs eslint right after every Write/Edit, feeding results back as non-blocking context.

None of these scripts reference a specific project by name or path — they're meant to be copied as-is.
