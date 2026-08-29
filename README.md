# Claude Code Policy Starter Kit

A starter kit and working agreement for agentic development with **Claude Code** — for individuals and teams who want enforced guardrails, a documented workflow, and consistent coding standards from day one. Think of it as a coding-standard contract: drop the contents of this repo into a new project and both humans and Claude start from the same rules.

Two boundaries are deliberate, and neither is "agnostic about everything":

- **Not tool-agnostic**: this kit targets Claude Code specifically (hooks, skills, rules, subagents live under `.claude/`).
- **TypeScript-based, framework-agnostic**: TypeScript is a precondition rather than a suggestion — the kit ships a pinned TypeScript/ESLint/Prettier/commitlint baseline, and the commit hooks, the post-edit lint feedback, and CI all depend on it. What stays open is everything above that line: frontend framework, backend framework, database, and testing tools are project choices. The default repo shape is a monorepo, yet the meaningful layers (`.ai/` docs, `planning/`, tooling configs, CI) carry over to any shape. Most of the kit isn't Node-specific at all — see [Using this outside TypeScript](#using-this-outside-typescript).

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
│   ├── post-edit-verify.sh       # PostToolUse/Write|Edit — surfaces eslint output for the touched file
│   ├── suggest-branch-cleanup.sh # PostToolUse/Bash — non-blocking: lists local branches after returning to main
│   └── remind-return-to-main.sh  # PostToolUse/Bash + pull_request_create — non-blocking: nudges back to main after a PR
├── agents/               # architecture-reviewer (read-only), backend-/frontend-implementer (hard-bounded)
├── rules/                # Path-scoped auto-loading of boundary/testing docs
└── skills/               # implement, refactor, bugfix, add-tests, update-docs,
                          # execute-task, address-pr-feedback, cleanup-merged-branches,
                          # setup-project (single-use adaptation wizard)
.github/
├── pull_request_template.md      # guard-pr-body.sh reads its ## sections dynamically
└── workflows/ci.yml              # Server-side enforcement: lint/typecheck/test/build,
                                  # commitlint on PR commits, PR body template check
planning/                 # Bounded task plans: templates/task-plan.md, active/, archive/
docs/                     # Architecture doc skeletons (01-… numbered), repo-settings
│                         # checklist, decisions/ (ADRs) — the layer .ai/ references
.husky/                   # pre-commit (lint-staged), commit-msg (commitlint)
package.json              # Pinned dev tooling + lint-staged block; workspaces default to apps/*, packages/*
commitlint.config.mjs     # Conventional commit types (synced with .ai/task-workflow.md)
eslint.config.mjs         # Framework-free flat-config base (TS + prettier); workspaces extend it
tsconfig.base.json        # Strict TS base — deliberately NO root path aliases (see alias rules)
.prettierrc / .prettierignore
.vscode/                  # Format-on-save + eslint fix-on-save defaults
```

## Using this in a new project

The fastest path: copy everything in, then run the `setup-project` skill in Claude Code — it walks through every step below interactively and deletes itself when done. Manually:

1. Copy the contents of this repo into the target project (or start the project from this repo). `chmod +x .ai/hooks/*.sh .husky/*`, then run `npm install` — the `prepare` script activates husky, so the commit hooks start working immediately.
2. Merge `.claude/settings.json` if the target already has one.
3. Edit `.github/pull_request_template.md`'s `##` sections to the project's conventions — `guard-pr-body.sh` reads whatever headers are present.
4. Adjust the project-shape parts:
   - **Monorepo**: keep everything. Update the boundary map at the top of `.ai/hooks/guard-domain-boundary.sh` and the `paths` globs in `.claude/rules/*.md` if the layout differs from `apps/backend`, `apps/frontend`, `packages/shared`.
   - **Frontend-only / backend-only**: delete the other side's `.ai/*-domain-boundaries.md` / `.ai/*-testing-patterns.md` files, the matching `.claude/rules/*` and implementer agent, and `.ai/shared-domain-boundaries.md`. `guard-domain-boundary.sh` no-ops harmlessly with no matching subagents.
5. Fill in the project-specific blanks: state library choices in `.ai/frontend-domain-boundaries.md`, file-naming table adjustments in `.ai/coding-standards.md`, and architecture doc references once the project has a `docs/`.
6. Adapt the root `package.json` — the commit tooling (`prepare: husky`, the lint-staged block, and every dev dependency) already ships wired and pinned, so this is only about making it yours:
   - Set `name`, `version`, `description`, and `license` to the project's own.
   - Adjust the `workspaces` globs if the layout differs from `apps/*` / `packages/*`, or drop the field entirely for a single-package project.
   - Add the scripts the kit deliberately leaves out — `typecheck`, `test`, `build`. The kit ships no TypeScript source, so it defines only the scripts it can actually run (`lint`, `format`, `format:check`); CI skips the rest via `--if-present` until the project defines them. See `docs/04-tooling-conventions.md`.
   - Leave the TypeScript major alone: it is pinned to 6.x because no `typescript-eslint` release supports TypeScript 7 yet. See `docs/decisions/0005-pin-typescript-6-until-typescript-eslint-supports-7.md`.

7. Apply the server-side settings in `docs/06-repo-settings.md` when creating the GitHub repository (branch protection, squash-merge, auto-delete head branches) — the hooks assume them.

## Using this outside TypeScript

The working agreement is the point; npm is just how this kit makes it enforceable. Those are separable, and the seam is cleaner than the pinned `package.json` suggests — a Python, Go, or C# project can take most of this as-is.

Carries over unchanged, with no Node involved:

- `.ai/` (the knowledge layer), `planning/`, `docs/` including the ADRs, and `.github/pull_request_template.md`.
- `.claude/skills/`, `.claude/agents/`, `.claude/rules/`.
- Five of the six hooks — `guard-git.sh`, `guard-pr-body.sh`, `guard-domain-boundary.sh`, `suggest-branch-cleanup.sh`, `remind-return-to-main.sh` — are plain bash + `jq`. Nothing in them knows what language the project is written in.

Needs an equivalent in the target ecosystem:

- `post-edit-verify.sh` — the one hook that shells out to eslint. Point it at `ruff`, `gofmt`, `dotnet format`, or whatever the project lints with; the hook contract (read the edited file path, return `additionalContext`) doesn't change.
- `package.json`, `tsconfig.base.json`, `eslint.config.mjs`, `.prettierrc`, `.prettierignore` — delete outright.
- husky + commitlint + lint-staged — the commit-time layer. `pre-commit` is the usual Python equivalent; the Conventional Commit types in `commitlint.config.mjs` are worth keeping as config for whatever enforces them, and `.ai/task-workflow.md` must stay synchronized with that list either way.
- `.github/workflows/ci.yml` — swap the npm steps. The job structure (verify / commitlint / PR-body template) is ecosystem-independent, and the PR-body job is already plain bash.
- A pass over `.ai/`: seven of its thirteen documents touch the TypeScript/Node ecosystem, but only `coding-standards.md` leans on it (the file-naming table, ESLint/Prettier as the owners of formatting, a test-runner reference). The other six are passing mentions — a `.ts` extension in an example, one eslint reference — and the boundary, workflow, and prompt-template documents don't mention it at all.

What you'd be replacing is the enforcement substrate, not the working agreement. If that trade ever becomes routine rather than hypothetical, the agnostic core is already isolated by directory and can be extracted then — doing it before there's a real non-TypeScript project to validate against is the kind of premature abstraction `.ai/task-workflow.md` warns about.

## What each layer gives you

- **Enforced policy (hooks)** — invariants agents can't forget under long sessions: no direct commits to `main`/`master`, no force-push, no staged secrets, PR bodies must follow the template (both `gh pr create` and MCP tools), implementer subagents can't cross domain boundaries, eslint feedback lands right after every edit.
- **Workflow knowledge (`.ai/`)** — the task lifecycle, agentic git collaboration workflow (branch → verify → PR → return to main), PR feedback loop, decomposition standards, prompt templates, and boundary/testing patterns split so path-scoped configs load only what's relevant.
- **Claude Code ergonomics (`.claude/`)** — skills that wrap the prompt templates, subagents with enforced (not just instructed) boundaries, and path-scoped rules that auto-load the right context.
- **Team hygiene (husky + commitlint + prettier)** — conventional commits and consistent formatting enforced at commit time, for humans and agents alike.
- **Server-side enforcement (CI)** — local hooks guide the session but can be bypassed; `.github/workflows/ci.yml` re-checks lint/typecheck/test/build, commit messages, and the PR body template on every PR.
- **Bounded task plans (`planning/`)** — a template and lifecycle for the task files that `execute-task` and the Task-File Execution Prompts treat as authoritative.
- **Non-blocking nudges** — not every hook is a gate: eslint feedback after each edit, a branch list when you return to `main`, and a return-to-`main` reminder after opening a PR. They back the recommended habits in `.ai/task-workflow.md` without failing a tool call. `cleanup-merged-branches` handles the pruning itself, since squash-merge makes `git branch --merged` unreliable.
- **A local escape hatch** — `.claude/settings.local.json` is gitignored and per-user, for machine-specific settings that must not become project policy. Nothing lives there by default: every mechanism above is deliberately shared, so the team and the agent read the same rules.

## Notes

- `post-edit-verify.sh` no-ops harmlessly in projects without eslint.
- None of the hook scripts reference a specific project by name; the only per-project edit is the boundary map in `guard-domain-boundary.sh`.
- Commit types are defined once in `commitlint.config.mjs` and mirrored in `.ai/task-workflow.md` — keep them synchronized.
