# Tooling Conventions

The reasoning behind the root tooling configs. The rules agents follow live in `.ai/coding-standards.md`; this document records why the setup looks the way it does.

## Build & Dev

Package manager: **npm**, with workspaces (`apps/*`, `packages/*`) matching the kit's default monorepo shape. npm needs no extra setup step in CI, which keeps `.github/workflows/ci.yml` readable for projects that adopt the kit without adopting its exact stack. Single-package projects drop the `workspaces` field; projects preferring pnpm or a workspace runner (turbo/nx) swap it here and in CI.

The globs resolving to nothing is intentional and harmless: the kit ships no workspaces of its own.

## Scripts: what the kit defines and why the rest are missing

The root `package.json` deliberately defines only the scripts the kit can actually run against itself: `lint`, `lint:fix`, `format`, `format:check`, plus `prepare` for husky.

`typecheck`, `test`, and `build` are **intentionally absent**. The kit ships no TypeScript source, so `tsc --noEmit` would fail with "No inputs were found" and a test runner would have nothing to run. CI calls every one of these with `--if-present`, so absent scripts are skipped rather than failed. Projects built from the kit add them as real workspaces appear.

This is what makes the kit self-verifying rather than aspirational: every script it declares passes on a fresh clone, and CI runs the same commands a developer runs locally.

## Lint & Format

`eslint.config.mjs` is a framework-free flat-config base (JS + TypeScript recommended, Prettier as an ESLint rule). Workspaces extend it and add their own framework plugins; the base stays framework-free so a React choice never leaks into backend linting.

Prettier runs as an ESLint rule rather than a separate pass so format drift surfaces through the same channel as lint errors — which is what lets `.ai/hooks/post-edit-verify.sh` report formatting problems to the agent immediately after each edit.

Enforcement runs at three levels, deliberately redundant because the first two are bypassable:

| Level             | Mechanism                        | Bypassable                       |
| ----------------- | -------------------------------- | -------------------------------- |
| During an AI edit | `post-edit-verify.sh` (eslint)   | Advisory only, never blocks      |
| At commit time    | husky `pre-commit` → lint-staged | Yes (`--no-verify`)              |
| On every PR       | `.github/workflows/ci.yml`       | No — the enforcement that counts |

Note that `post-edit-verify.sh` and lint-staged both depend on installed dependencies (`npx --no-install`). Without `npm install` they no-op silently, which reads as "clean" rather than "not running" — the reason the kit ships a `package.json` and lockfile rather than asking each project to assemble one.

Prettier formats fenced code blocks inside markdown too. With `trailingComma: "all"`, a `jsonc` example in a doc gets trailing commas added; keep that in mind when writing JSON examples that readers will copy.

## Module Formats

ESM-first: the root `package.json` sets `"type": "module"`, and tooling configs use the explicit `.mjs` extension. `eslint.config.mjs` carries a CJS escape hatch for `**/*.config.js` files that ecosystem tools still require. See `.ai/coding-standards.md → Module Format Rules`.

## TypeScript

`tsconfig.base.json` is a strict base every workspace extends. It deliberately contains **no `paths`** — path aliases are per-workspace and may only resolve into that workspace's own `src/`. See `docs/decisions/0003-workspace-scoped-path-aliases.md` and `.ai/architecture-rules.md → Module Resolution & Alias Rules`.

TypeScript is pinned to **6.x**, not the 7.x `latest`, because no published `typescript-eslint` release supports TypeScript 7 — and type-aware linting (`projectService: true`) is load-bearing here. Treat the TypeScript major as a deliberate constraint rather than routine maintenance: see `docs/decisions/0005-pin-typescript-6-until-typescript-eslint-supports-7.md` for the evidence and the revisit trigger.

## Commit Conventions

`commitlint.config.mjs` defines the approved Conventional Commit types. That list is duplicated in `.ai/task-workflow.md → Agentic Git Collaboration Workflow` for agents to read without parsing the config — **the two must stay synchronized**; changing one means changing the other.
