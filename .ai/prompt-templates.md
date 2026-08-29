# Prompt Templates

This document defines reusable prompt patterns for AI-assisted development inside this repository, to standardize prompt structure, reduce unnecessary token usage, and keep task decomposition deterministic.

Prompts should remain: scoped, explicit, architecture-aware, verification-oriented.

---

## Core Prompt Philosophy

Good prompts should:

- define clear scope
- define explicit constraints
- load only relevant context
- define expected verification
- minimize ambiguity
- preserve architectural boundaries

Avoid broad implementation requests without boundaries.

---

## Standard Prompt Structure

Preferred structure:

```txt
Context
Task
Constraints
Affected Areas
Verification
Output Expectations
```

---

## Context Loading Template

Use this template before implementation tasks. For detailed context loading guidance, see `.ai/README.md → Context Loading Strategy`.

```txt
Required:
- .ai/task-workflow.md

Task-specific:
- <smallest relevant .ai/* document>
- <smallest relevant docs/* document, if the project has docs/>

Optional:
- additional architecture docs only after a concrete uncertainty appears
```

Prompts should avoid repeating broad context lists when a task-specific context set is enough.

---

## Implementation Prompt

Use for any implementation task. Load the relevant domain-boundaries file if applicable.

```txt
Read:

- .ai/task-workflow.md
- .ai/architecture-rules.md
- .ai/coding-standards.md
- the relevant architecture docs for the affected area (if the project has docs/)

Optional (add only if the task crosses domain/service ownership):
- the domain's .ai/*-domain-boundaries.md file
- .ai/implementation-patterns.md

Task:
<implementation task>

Constraints:
- preserve existing orchestration boundaries
- avoid unrelated refactors
- reuse existing patterns
- preserve runtime contracts
- (frontend) keep server state and orchestration state separated; no UI-layer orchestration leakage
- (shared) keep contracts runtime-safe, serialization-safe, environment-agnostic; preserve backward compatibility unless the task explicitly changes the contract

Affected Areas:
- <modules / workspaces>

Verification:
- run the smallest relevant tests for the affected area
- run lint/typecheck if required
- (shared) run consumer checks if the change affects existing contracts

Output:
- summarize architectural impact
- summarize verification results
```

---

## Refactor Prompt

```txt
Read:

- .ai/architecture-rules.md
- .ai/implementation-patterns.md
- .ai/coding-standards.md
- relevant architecture docs

Task:
Refactor <target area>.

Goals:
- improve boundary clarity
- reduce duplication
- preserve deterministic behavior

Constraints:
- avoid changing public runtime contracts
- avoid broad rewrites
- preserve testing conventions

Verification:
- run relevant scoped verification
- ensure behavior remains unchanged
```

---

## Testing Prompt

```txt
Read:

- .ai/testing-patterns.md

Optional (add the file matching the target area):
- .ai/backend-testing-patterns.md
- .ai/frontend-testing-patterns.md

Task:
Add or update tests for <target behavior>.

Requirements:
- validate observable behavior
- preserve existing testing conventions
- avoid implementation-detail assertions
- inspect nearby tests before implementing

Verification:
- run relevant test suites
```

---

## Documentation Prompt

```txt
Read:

- README.md
- relevant docs/* (if present)
- relevant .ai/* files

Task:
Update documentation for <change>.

Requirements:
- preserve documentation layering
- keep README concise
- place implementation reasoning inside docs/
- place operational workflow guidance inside .ai/
- preserve existing formatting conventions
```

---

## Bugfix Prompt

```txt
Read:

- relevant architecture docs
- relevant workflow docs

Task:
Fix <bug description>.

Requirements:
- identify root cause before implementation
- preserve existing orchestration behavior
- avoid unrelated refactors
- minimize implementation scope

Verification:
- reproduce issue before fix
- verify issue after fix
- run relevant verification commands
```

---

## Small Scoped Task Prompt

```txt
Task:
Implement <small isolated change>.

Constraints:
- preserve existing patterns
- avoid introducing new abstractions
- keep implementation scoped
- avoid unrelated file changes

Verification:
- run minimal relevant verification
```

---

## Task-File Execution Prompts

Use these wrappers when a bounded task plan file already defines the authoritative scope, constraints, affected areas, verification, and completion criteria.

Prefer the compact wrapper for routine execution. Use the controlled wrapper when dependency checks and Git workflow completion need additional emphasis.

### Compact Task Execution Prompt

```txt
Execute <path/to/task-file.md>.

Follow `.ai/task-workflow.md` (AGENTS.md is already in context).
The task file is authoritative. Keep scope bounded, and complete its verification.

For Git workflow steps (branching, committing, PR creation), see `.ai/task-workflow.md → Agentic Git Collaboration Workflow`.
When creating a PR, you MUST read `.github/pull_request_template.md` and use its exact structure for the PR body.

Report the changed files and verification results.
```

### Controlled Task Execution Prompt

```txt
Execute:

<path/to/task-file.md>

Follow `.ai/task-workflow.md` (AGENTS.md is already in context).

Treat the task file as the authoritative source for scope, constraints, affected areas, verification, and completion criteria.

Before implementation:
- confirm task dependencies are complete

Keep changes strictly bounded to the task.
Do not expand scope or perform unrelated refactors.

Run all verification required by the task.

For Git workflow steps (branching, committing, PR creation), see `.ai/task-workflow.md → Agentic Git Collaboration Workflow`.
When creating a PR, you MUST read `.github/pull_request_template.md` and use its exact structure for the PR body.

Report:
- changed files
- verification results
```

---

## Architecture Review Prompt

```txt
Read:

- README.md
- relevant architecture docs
- .ai/architecture-rules.md
- .ai/domain-boundaries.md
- the side-specific .ai/*-domain-boundaries.md file(s) the review touches

Task:
Review <target implementation or proposal>.

Focus:
- boundary consistency
- orchestration clarity
- runtime contract safety
- implementation drift
- scalability concerns
- unnecessary abstraction

Output:
- architectural risks
- suggested improvements
- boundary violations
- scalability concerns
```

---

## AI Review Checklist

For the standard review checklist, see `.ai/task-workflow.md → Final Review`.

---

## Prompt Anti-Patterns

Avoid prompts like:

```txt
"Refactor the authentication system"
"Improve architecture"
"Clean up the frontend"
```

Prefer:

```txt
"Extract refresh-session coordination into isolated orchestration service"
"Align frontend route lifecycle behavior with existing orchestration patterns"
```

---

## Long-Term Direction

Prompt templates should support: deterministic AI collaboration, architecture-aware implementation, low-drift engineering workflows, reusable development patterns, and bounded task execution.
