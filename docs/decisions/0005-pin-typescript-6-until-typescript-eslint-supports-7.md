# 0005 — Pin TypeScript 6 until typescript-eslint supports TypeScript 7

- **Status**: Accepted
- **Date**: 2026-07-16
- **Deciders**: Enes Yılmaz

## Context

Adding the root `package.json` meant pinning a TypeScript version for the kit and every project started from it. TypeScript's `latest` is 7.0.2 — the Go-based native port — but no published `typescript-eslint` release supports it:

- `typescript-eslint@8.64.0` (`latest`, published 2026-07-13) declares `typescript: ">=4.8.4 <6.1.0"`.
- No v9 or v10 exists; the registry carries only `rc-v8`, `latest`, and `canary` tags.
- The `canary` build (`8.64.1-alpha.3`) declares the same `<6.1.0` ceiling.
- The sub-packages (`@typescript-eslint/parser`, `@typescript-eslint/typescript-estree`) declare the same range, so bypassing the umbrella package does not help.

This is not a stale peer range. `typescript-eslint` publishes actively, and type-aware linting depends directly on TypeScript's JavaScript compiler API — the surface the native port replaces. Supporting TS 7 is an architectural migration for that project, not a version-range bump.

`eslint.config.mjs` enables type-aware linting via `parserOptions.projectService: true`. On TypeScript 7 that configuration breaks, so TS 7 and this kit's lint layer cannot coexist today.

## Decision

Pin `typescript` to `^6.0.3` — the newest stable release satisfying `typescript-eslint`'s peer range — and keep type-aware linting enabled. Revisit when `typescript-eslint` publishes a release whose `typescript` peer range admits 7.x.

## Alternatives Considered

- **Take TypeScript 7 and drop type-aware linting**: rejected. It would mean removing `projectService: true` and the rules that depend on it. A kit whose purpose is enforced guardrails should not weaken its own lint layer to chase a major version.
- **Take TypeScript 7 and pin a second TypeScript 6 for linting only**: rejected. Two compiler versions in one tree produce conflicting diagnostics between editor, lint, and build, and the resulting setup contradicts the clarity the kit is meant to provide.
- **Leave `typescript` unpinned (`*` or `latest`)**: rejected. `npm install` would resolve to 7.x and break linting on a fresh clone, turning a documented constraint into an intermittent failure.

## Consequences

- Type-aware linting keeps working out of the box on a fresh clone; the kit verifies itself.
- Projects started from this kit inherit TypeScript 6 and cannot adopt TS 7 features until this decision is revisited. Projects needing TS 7 sooner must accept the type-aware-linting tradeoff above and record their own ADR superseding this one.
- **Revisit trigger**: a `typescript-eslint` release whose `typescript` peer range admits 7.x. Verify with `npm view typescript-eslint peerDependencies`. Until then, treat the TypeScript major in `package.json` as load-bearing rather than routine maintenance — a Dependabot-style major bump to 7.x must not be merged on its own.
