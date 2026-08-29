---
name: setup-project
description: Use once, right after dropping this starter kit into a new project (or starting a project from it), to adapt every placeholder to the project's actual shape. Walks through project type, layout, boundary map, rules globs, PR template, state libraries, and tooling wiring - asking before changing.
---

Adapt the starter kit to this project. Work through the checklist below in order, asking the user for each decision you can't infer from the repository itself. Make one bounded pass; report every file you changed at the end.

1. **Project shape**: ask whether this is a monorepo, frontend-only, or backend-only project, and what the actual directory layout is (default assumption: `apps/backend`, `apps/frontend`, `packages/shared`).
2. **Prune by shape**: frontend-only → delete `.ai/backend-domain-boundaries.md`, `.ai/backend-testing-patterns.md`, `.claude/rules/backend.md`, `.claude/agents/backend-implementer.md`, `.ai/shared-domain-boundaries.md`, `.claude/rules/shared.md`. Backend-only → the mirror set. Monorepo → keep everything.
3. **Boundary map**: update the map at the top of `.ai/hooks/guard-domain-boundary.sh` to the real layout and the agents that remain.
4. **Rules globs**: update the `paths` frontmatter in every remaining `.claude/rules/*.md` to the real layout.
5. **PR template**: ask what sections the team wants in `.github/pull_request_template.md` (keep `##` headers - `guard-pr-body.sh` and the CI pr-template job read them dynamically).
6. **Frontend choices** (if a frontend exists): fill the server-state and orchestration-state library choices in `.ai/frontend-domain-boundaries.md`.
7. **Naming table**: adjust the file-naming table in `.ai/coding-standards.md` to the project's frameworks.
8. **Tooling wiring**: the root `package.json` already ships wired (`prepare: husky`, the lint-staged block, pinned dev dependencies). Adapt rather than assemble: set `name`/`version`/`description`/`license` to the project's own, adjust the `workspaces` globs to the real layout (drop the field for a single-package project), and add the scripts the kit leaves out once there is something to run — `typecheck`, `test`, `build`. Do not bump the TypeScript major to 7.x: `typescript-eslint` does not support it yet (`docs/decisions/0005-pin-typescript-6-until-typescript-eslint-supports-7.md`). Then run `chmod +x .ai/hooks/*.sh .husky/pre-commit .husky/commit-msg` and `npm install` (this activates husky).
9. **CI**: adjust `.github/workflows/ci.yml` Node version / package manager if the project differs.
10. **TS/ESLint base**: keep `tsconfig.base.json` and `eslint.config.mjs` at the root; have each workspace extend them. When adding per-workspace aliases, keep them scoped to that workspace's own `src/` (see `.ai/architecture-rules.md → Module Resolution & Alias Rules`).
11. **Docs layer**: fill in the `docs/` skeletons that already have answers (01-architecture-overview at minimum); record any structural decision made during setup as an ADR in `docs/decisions/`. Apply `docs/06-repo-settings.md` to the GitHub repository settings.
12. **Docs sync**: update `README.md`, and `CLAUDE.md` so they describe the project's actual shape (remove pruned files from listings). Delete this skill's own directory (`.claude/skills/setup-project/`) as the final step - it is single-use.

Do not implement product features as part of setup. When a decision is ambiguous, ask instead of guessing.
