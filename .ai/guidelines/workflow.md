# Workflow

This document defines the standard workflow for AI-assisted task execution inside this repository: bounded implementation scope, deterministic architectural evolution, explicit verification, and minimal drift.

---

## Core Principles

The agent should follow the core principles defined in `AGENTS.md`. Key task-specific principles: prefer small isolated tasks, reuse existing patterns, validate assumptions before introducing abstractions.

---

## Standard Task Lifecycle

Every task should follow this sequence:

```txt
Context Loading
→ Scope Identification
→ Constraint Validation
→ Implementation
→ Verification
→ Documentation Sync
→ Final Review
```

### 1. Context Loading

Load only the smallest relevant context set. See `.ai/README.md → Context Loading Strategy`.

### 2. Scope Identification

Before implementation, identify:

- affected workspaces or modules
- affected domains
- affected runtime contracts
- required verification scope

Tasks should remain bounded whenever possible.

Preferred:

```txt
Extract refresh token hashing into isolated service
```

Avoid:

```txt
Refactor authentication architecture
```

### 3. Constraint Validation

Before implementation, verify the constraints in your task domain remain valid. See `architecture-rules.md` for architectural invariants, domain boundary constraints, and runtime contract requirements.

### 4. Implementation Rules

During implementation, follow coding and architectural constraints. See `coding-standards.md` for naming conventions, typing rules, shared contract rules, refactoring discipline, and testing expectations.

### 5. Verification

Run the smallest relevant verification set. See `testing-patterns.md → Verification Philosophy` for guidance on proportional verification.

### 6. Documentation Sync

Documentation must remain synchronized with implementation changes. See `coding-standards.md → Documentation Standards`.

### 7. Final Review

Before completing a task, verify:

- scope remained bounded
- implementation matches existing patterns
- runtime contracts remain consistent
- unrelated files were not modified
- verification succeeded
- documentation remains synchronized

---

## Preferred Task Characteristics

Good AI-assisted tasks are: isolated, deterministic, verifiable, architecture-aware, testable, and incrementally scoped.

---

## Agentic Git Collaboration Workflow

Feature work must not be implemented directly on `main`.

Start bounded work from an up-to-date `main` branch, then create one focused branch per task using:

```txt
<type>/<kebab-case-description>
```

Examples:

```txt
feat/chunk-library
fix/nested-route-reload
refactor/query-hooks
docs/ai-workflow-guidance
```

Use Conventional Commit messages in this format:

```txt
<type>(optional-scope): <imperative lowercase description>
```

Repository-approved commit types, synchronized with `commitlint.config.mjs`, are:

```txt
build
chore
ci
docs
feat
fix
perf
planning
refactor
revert
style
test
```

For each bounded task:

1. Inspect the current branch and working tree before editing.
2. Create a focused branch before implementation.
3. Keep commits bounded and logically grouped.
4. Run proportional verification before committing.
5. Inspect the staged diff before committing.
6. Push the task branch after successful verification.
7. Open a pull request targeting `main`.
8. Populate the pull request description strictly following the `.github/pull_request_template.md` format.
9. Never merge the pull request automatically unless explicitly requested.
10. After the pull request is open, return the local working directory to an up-to-date `main` branch without deleting the open task branch. Treat this as a recommended habit rather than a hard gate.

Additional safeguards:

- Do not commit unrelated user changes.
- Do not force-push. `guard-git.sh` denies it unconditionally: a hook sees only the command, never the conversation, so it cannot tell an explicitly requested rewrite from an unprompted one. This is deliberate — force-push is the one operation whose blast radius justifies a human in the loop. When a history rewrite is genuinely needed, the agent prepares the branch locally, verifies it, and reports the exact command for the user to run themselves. Do not work around the guard by wrapping the push in a script or alias; that defeats the guard rather than satisfying it.
- Do not commit secrets, generated output, or local environment files.
- After a pull request is merged, the merged local task branch may be deleted. The deciding signal is containment — whether merging the branch into `main` would still change `main` — not any string or API field. `git merge-tree --write-tree main <branch>` answers it directly: if the tree it prints equals `git rev-parse main^{tree}`, the branch carries nothing `main` lacks and is safe to delete. This holds whatever the merge strategy, however far `main` has moved since, and however the merge commit was titled. Ancestry checks (`git branch --merged`) and PR-title matching are both unreliable here and must not decide the outcome — see the `cleanup-merged-branches` skill for why, and for the full detection-and-cleanup procedure. Remote task branches should be removed automatically through the repository setting `Automatically delete head branches`.
- Never delete `main`, active branches, unmerged branches, or intentionally retained backup branches.

### Addressing PR Review Feedback

When a pull request has open review comments that need to be fixed:

1. Identify the target PR: the current branch's PR via the git provider, or an explicit PR number the task specifies.
2. Fetch review comments together with their thread-resolution state from the git provider. Only unresolved threads need action — do not rely on a comment simply existing, since addressed/outdated comments remain visible in the API.
3. Group unresolved comments by the file path they target, then classify each file by ownership per `.ai/guidelines/architecture.md`.
4. Delegate comments to the appropriate subagents if the project uses them, or handle them directly.
5. Run proportional verification for each touched domain per `testing-patterns.md` before considering a comment addressed.
6. Once verified, commit the fix with a Conventional Commit message and push it to the PR's existing branch. Invoking this workflow is itself the Git workflow completion request for that fix — pushing to the PR's own branch does not need a separate ask, unlike opening a new PR or merging (see the Git Workflow Completion Boundary below, which still governs those).
7. For each addressed thread, reply on the git provider referencing the fix (e.g. the commit SHA) and mark the thread resolved. Leave a thread unresolved and unreplied whenever a comment couldn't be confidently addressed (ambiguous, out of scope, or already stale) — report the reason instead of forcing a resolution.
8. Report which comments were addressed (and by what — subagent or main conversation), which were replied to and resolved, and which were left alone with reasons.

### Git Workflow Completion Boundary

Implementation-only task completion does not imply permission to mutate the external repository. Commit, push, and pull request creation should occur only when the task prompt or user explicitly requests Git workflow completion.

When Git workflow completion is explicitly requested:

1. Inspect `git status` and the staged diff.
2. Stage only task-related files.
3. Commit with the requested Conventional Commit message, or propose a compliant message when none is provided.
4. Push the current focused task branch to `origin`.
5. Open a pull request targeting `main`.
6. Read `.github/pull_request_template.md` and populate the pull request description using its exact structure.
7. Report the branch name, commit SHA, and pull request URL.
8. Do not merge the pull request unless explicitly requested.
9. Confirm the working tree is clean, switch the local working directory to `main`, and update it with `git pull --ff-only origin main`.
10. Keep the open task branch available locally and remotely until the pull request is merged or explicitly closed.

---

## Task Decomposition Standards

Bounded task plans live as files under `planning/` — see `planning/README.md` for the template and archive lifecycle.

A bounded task has one primary outcome, a small affected area, explicit constraints, and a deterministic verification path.

Bounded tasks should define:

- the specific behavior, document, workflow, or artifact being changed
- the files, modules, or documentation areas expected to change
- the runtime contracts or layers that must remain unchanged
- the smallest relevant verification command or manual check
- explicit out-of-scope areas

A task is too broad when it combines multiple execution modes or affects multiple ownership boundaries without a clear split.

Too-broad task signals include:

- mixing planning, tooling evaluation, implementation, and review in one task
- changing frontend and backend behavior together without an explicit contract reason
- modifying production code while also redefining workflow guidance
- introducing new abstractions before validating existing patterns
- requiring repository-wide verification for an otherwise unclear scope
- lacking explicit affected areas or out-of-scope areas

A task is ready for execution when its scope can be verified before implementation starts.

Ready-for-execution tasks should have:

- a single objective
- required context listed explicitly
- affected areas identified
- constraints that preserve architecture boundaries
- deterministic verification steps
- completion criteria that can be checked without guessing intent
- an **Agent Execution Prompt** section at the bottom, using one of the wrappers from `.ai/guidelines/prompt-templates.md`

When a task is too broad, split it before implementation.

---

## Review Discipline

Reviews should be repeatable from the task plan, changed files, and verification results.

Before review, confirm:

- scope discipline: the change has one primary outcome
- implementation boundedness: changed files match the affected areas
- verification proportionality: checks match the risk and scope
- documentation synchronization: related guidance stays consistent
- architecture boundary preservation: production code and runtime contracts are unchanged unless explicitly scoped
- markdown consistency: formatting follows `.ai/guidelines/standards.md`

---

## Anti-Patterns

See `architecture-rules.md → Anti-Patterns` for the consolidated list of architectural anti-patterns.

---

## Escalation Rules

Agents should stop and request clarification when:

- architectural direction becomes ambiguous
- runtime boundaries are unclear
- multiple competing abstractions emerge
- the requested change affects multiple layers at once
- implementation conflicts with documented conventions

Do not guess architectural intent.
