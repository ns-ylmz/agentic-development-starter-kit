# Documentation Index

This directory owns architecture reasoning, runtime behavior, and reference documentation — the "why" behind the code. Operational AI workflow guidance lives in `.ai/`; orientation lives in the root `README.md` (see `.ai/README.md → Relationship to Other Documentation`).

The numbered files are skeletons: fill them in as the project takes shape, keep the numbering for stable references, and add new numbered docs as new architectural areas appear. `.ai/` documents reference this layer as "the relevant architecture docs".

```txt
docs/
├── 01-architecture-overview.md    # System shape, workspaces, high-level data flow
├── 02-security-model.md           # AuthN/AuthZ, session lifecycle, secrets handling
├── 03-testing-foundation.md       # Test layers, tooling, how verification maps to CI
├── 04-tooling-conventions.md      # Build/lint/format tooling decisions and module formats
├── 05-environment-configuration.md# Env vars, config loading, per-environment behavior
├── 06-repo-settings.md            # Required GitHub repo settings (branch protection etc.)
└── decisions/                     # Architecture Decision Records (ADRs)
```
