---
name: cleanup-merged-branches
description: Use when asked to clean up, delete, or prune local git branches that have already been merged (e.g. "clean up merged branches", "delete old/stale branches", "branch temizliği yap"). Also relevant right after returning to main following a merged PR.
---

Follow `.ai/task-workflow.md → Agentic Git Collaboration Workflow` (local branch cleanup):

1. List local branches other than `main`/`master`.
2. Do NOT rely on `git branch --merged` or any local ancestry check. This kit assumes squash-merge (`docs/06-repo-settings.md`), and a squash-merged branch's commits never become ancestors of `main` — ancestry checks produce false negatives. In a project that merges with true merge commits instead, ancestry checks are valid and this whole procedure is unnecessary; confirm the merge strategy before applying it.
3. Do NOT trust the git provider's `merged`/`state` API fields as the primary signal either. These have been observed to misreport `merged: false` for PRs that were demonstrably merged. Treat them as, at best, a secondary cross-check — never as the deciding signal.
4. Primary detection method: find the pull request associated with each branch (search pull requests authored by the user, or look up a known PR number) to read its title, then check whether `git log --oneline main` contains a commit message matching that title exactly. Under squash-merge the provider uses the PR title as the squash commit message by definition, so a match is authoritative proof the branch's changes are in `main`, independent of any API field. The one case it doesn't hold is a commit message manually retitled at merge time — a deliberate, unusual action worth noticing rather than assuming.
5. Only delete a local branch once its PR title is confirmed present in `main`'s commit log this way. If an API `merged`/`state` field disagrees with the title-match result, trust the title-match and note the discrepancy in your report. Use a safe delete (`git branch -d`) when git recognizes the merge on its own; otherwise use an explicit force delete (`git branch -D`), but only after the title-match confirmation from step 4 — never based on assumption, and never for a branch whose merge status couldn't be confirmed.
6. Leave alone: `main`/`master`, any branch with no corresponding PR found, and any branch whose PR title cannot be found in `main`'s commit log (still open, closed without merging, or unconfirmed).
7. Report exactly which branches were deleted and which were left alone, with the reason for each, including any API-field vs. title-match discrepancies noticed along the way.

Deleting a branch is irreversible from the user's point of view, so confirm before deleting anything that step 4 could not positively prove was merged. Reporting an unconfirmed branch and leaving it is always the correct outcome — never a failure.

Do not restate this procedure elsewhere — `.ai/task-workflow.md` is the single source of truth, shared with any other agent tool used on this repo.
