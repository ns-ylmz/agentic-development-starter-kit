# Claude Code Policy Starter Kit

A starter kit and working agreement for agentic development with **Claude Code** — for individuals and teams who want enforced guardrails, a documented workflow, and consistent coding standards from day one. Think of it as a coding-standard contract: drop the contents of this repo into a new project and both humans and Claude start from the same rules.

Two kinds of agnosticism are deliberate, in opposite directions:

- **Not tool-agnostic**: this kit targets Claude Code specifically (hooks, skills, rules, subagents live under `.claude/`).
- **Technology-agnostic**: TypeScript is the baseline standard, but frontend framework, backend framework, database, and testing tools are project choices. The default repo shape is a monorepo, yet the meaningful layers (`.ai/` docs, `planning/`, tooling configs, CI) carry over to any shape.

The layering principle: **`CLAUDE.md` stays lean, knowledge lives in `.ai/`, mechanisms live in `.claude/` and only reference the knowledge — never restate it.**

## Layout

```txt
CLAUDE.md                 # Lean entrypoint: principles, layer map, mechanism wiring
.ai/
├── README.md             # Context loading strategy and guidance ownership
├── task-workflow.md      # Task lifecycle + agentic git collaboration workflow
├── architecture-rules.md # Architectural invariants (incl. workspace alias rules)
├── coding-standards.md   # TS-first coding/naming/markdown conventions
├── implementation-patterns.md
├── domain-boundaries.md  # + backend-/frontend-/shared- specific boundary files
├── testing-patterns.md   # + backend-/frontend- specific testing files
└── prompt-templates.md   # Reusable Context/Task/Constraints prompt formats
.claude/
├── settings.json         # Wires the hooks below + safe permission allowlist
├── hooks/
│   ├── guard-git.sh              # PreToolUse/Bash — blocks main/master commits, force-push, staged secrets
│   ├── guard-pr-body.sh          # PreToolUse/Bash + pull_request_create — enforces PR template sections (gh CLI and MCP)
│   ├── guard-domain-boundary.sh  # PreToolUse/Edit|Write — blocks implementer subagents from the other domain (map-driven)
│   └── post-edit-verify.sh       # PostToolUse/Write|Edit — surfaces eslint output for the touched file
├── agents/               # architecture-reviewer (read-only), backend-/frontend-implementer (hard-bounded)
├── rules/                # Path-scoped auto-loading of boundary/testing docs
└── skills/               # implement, refactor, bugfix, add-tests, update-docs,
                          # execute-task, address-pr-feedback,
                          # setup-project (single-use adaptation wizard)
.github/
├── pull_request_template.md      # guard-pr-body.sh reads its ## sections dynamically
└── workflows/ci.yml              # Server-side enforcement: lint/typecheck/test/build,
                                  # commitlint on PR commits, PR body template check
planning/                 # Bounded task plans: templates/task-plan.md, active/, archive/
docs/                     # Architecture doc skeletons (01-… numbered), repo-settings
│                         # checklist, decisions/ (ADRs) — the layer .ai/ references
.husky/                   # pre-commit (lint-staged), commit-msg (commitlint)
commitlint.config.mjs     # Conventional commit types (synced with .ai/task-workflow.md)
eslint.config.mjs         # Framework-free flat-config base (TS + prettier); workspaces extend it
tsconfig.base.json        # Strict TS base — deliberately NO root path aliases (see alias rules)
.prettierrc / .prettierignore
.vscode/                  # Format-on-save + eslint fix-on-save defaults
```

## Using this in a new project

The fastest path: copy everything in, then run the `setup-project` skill in Claude Code — it walks through every step below interactively and deletes itself when done. Manually:

1. Copy the contents of this repo into the target project (or start the project from this repo). `chmod +x .claude/hooks/*.sh .husky/*`.
2. Merge `.claude/settings.json` if the target already has one.
3. Edit `.github/pull_request_template.md`'s `##` sections to the project's conventions — `guard-pr-body.sh` reads whatever headers are present.
4. Adjust the project-shape parts:
   - **Monorepo**: keep everything. Update the boundary map at the top of `.claude/hooks/guard-domain-boundary.sh` and the `paths` globs in `.claude/rules/*.md` if the layout differs from `apps/backend`, `apps/frontend`, `packages/shared`.
   - **Frontend-only / backend-only**: delete the other side's `.ai/*-domain-boundaries.md` / `.ai/*-testing-patterns.md` files, the matching `.claude/rules/*` and implementer agent, and `.ai/shared-domain-boundaries.md`. `guard-domain-boundary.sh` no-ops harmlessly with no matching subagents.
5. Fill in the project-specific blanks: state library choices in `.ai/frontend-domain-boundaries.md`, file-naming table adjustments in `.ai/coding-standards.md`, and architecture doc references once the project has a `docs/`.
6. Wire the commit tooling in the root `package.json`:

```jsonc
{
  "scripts": { "prepare": "husky" },
  "lint-staged": {
    "*.{ts,tsx,js}": ["eslint --fix", "prettier --write"],
    "*.{json,md}": ["prettier --write"]
  },
  "devDependencies": {
    "@commitlint/cli": "...",
    "@commitlint/config-conventional": "...",
    "@eslint/js": "...",
    "eslint": "...",
    "eslint-config-prettier": "...",
    "eslint-plugin-prettier": "...",
    "globals": "...",
    "husky": "...",
    "lint-staged": "...",
    "prettier": "...",
    "typescript": "...",
    "typescript-eslint": "..."
  }
}
```

7. Apply the server-side settings in `docs/06-repo-settings.md` when creating the GitHub repository (branch protection, squash-merge, auto-delete head branches) — the hooks assume them.

## What each layer gives you

- **Enforced policy (hooks)** — invariants agents can't forget under long sessions: no direct commits to `main`/`master`, no force-push, no staged secrets, PR bodies must follow the template (both `gh pr create` and MCP tools), implementer subagents can't cross domain boundaries, eslint feedback lands right after every edit.
- **Workflow knowledge (`.ai/`)** — the task lifecycle, agentic git collaboration workflow (branch → verify → PR → return to main), PR feedback loop, decomposition standards, prompt templates, and boundary/testing patterns split so path-scoped configs load only what's relevant.
- **Claude Code ergonomics (`.claude/`)** — skills that wrap the prompt templates, subagents with enforced (not just instructed) boundaries, and path-scoped rules that auto-load the right context.
- **Team hygiene (husky + commitlint + prettier)** — conventional commits and consistent formatting enforced at commit time, for humans and agents alike.
- **Server-side enforcement (CI)** — local hooks guide the session but can be bypassed; `.github/workflows/ci.yml` re-checks lint/typecheck/test/build, commit messages, and the PR body template on every PR.
- **Bounded task plans (`planning/`)** — a template and lifecycle for the task files that `execute-task` and the Task-File Execution Prompts treat as authoritative.
- **Personal-vs-team separation** — personal habits go in gitignored `*.local.sh` hooks + `.claude/settings.local.json`, never in shared policy.

## Notes

- `post-edit-verify.sh` no-ops harmlessly in projects without eslint.
- None of the hook scripts reference a specific project by name; the only per-project edit is the boundary map in `guard-domain-boundary.sh`.
- Commit types are defined once in `commitlint.config.mjs` and mirrored in `.ai/task-workflow.md` — keep them synchronized.
