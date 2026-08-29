# AGENTS.md

This repository is a working agreement for agentic development — a coding-standard contract for individuals and teams. The technology stack is agnostic: this repo acts as a baseline template for AI-assisted development for any framework or language.

This file stays lean on purpose. Detailed knowledge lives in `.ai/` (reference documents) and agent-specific mechanisms live in their respective configuration folders (e.g., `.agents/` for Antigravity, or `.claude/` for Claude Code). When adding guidance, put the content in `.ai/` and reference it — don't grow this file.

## Core Principles

Prioritize: small and bounded changes, explicit architectural boundaries, deterministic runtime behavior, reusable implementation patterns, synchronized runtime contracts.

## Primary References

Before making any non-trivial change, read `README.md` and `.ai/guidelines/workflow.md`. This applies whether or not the request uses one of the wrapped prompts in `.ai/guidelines/prompt-templates.md` — a plain, ad-hoc request ("fix this bug", "add this field") still goes through the task lifecycle in `.ai/guidelines/workflow.md` (scope identification, constraint validation, verification, git workflow). Then load only the task-relevant documentation: see `.ai/README.md → Context Loading Strategy`.

## Layer Map

- `.ai/` — reference documents: task workflow, prompt templates, architecture/coding/testing/boundary rules. The canonical knowledge layer; everything else points here. Entry: `.ai/README.md`.
- `docs/` — architecture reasoning, `docs/decisions/` ADRs, `docs/06-repo-settings.md` server-side settings.
- `planning/` — bounded task plans (template + active/archive lifecycle).
