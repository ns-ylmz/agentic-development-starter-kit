---
name: address-pr-feedback
description: Use when asked to fetch and fix PR review comments (e.g. "address the review feedback", "fix the review comments on PR #71"). Fetches unresolved review comments, classifies each by domain, delegates fixes to the implementer subagents where they exist, then pushes the fix and replies/resolves on the PR.
---

Follow `.ai/task-workflow.md → Agentic Git Collaboration Workflow → Addressing PR Review Feedback` exactly:

1. Identify the target PR: the current branch's PR via the git provider, or an explicit PR number the user gave.
2. Fetch review comments together with their thread-resolution state from the git provider. Only unresolved threads need action.
3. Classify each unresolved comment's file by `.ai/domain-boundaries.md` ownership.
4. Delegate backend comments to the `backend-implementer` subagent and frontend comments to the `frontend-implementer` subagent — one call per domain, batching that domain's comments together. Handle shared-package and cross-cutting comments (docs, root config) directly in this conversation, following the `implement` skill or whichever skill matches the affected area.
5. Run proportional verification per `.ai/testing-patterns.md` for each touched domain.
6. Once verified, commit the fix and push it to the PR's existing branch — no separate ask needed for this push, since closing the loop on the PR is this workflow's whole point.
7. For each addressed thread, reply referencing the fix (e.g. the commit SHA) and mark it resolved. Leave unaddressed threads alone — no reply, no resolve — and report why.
8. Report which comments were addressed (and by what), which were replied to and resolved, and which were left alone with reasons.

Do not restate the procedure here — `.ai/task-workflow.md` is the single source of truth.
