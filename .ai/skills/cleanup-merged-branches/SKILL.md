---
name: cleanup-merged-branches
description: Use when asked to clean up, delete, or prune local git branches that have already been merged (e.g. "clean up merged branches", "delete old/stale branches", "branch temizliği yap"). Also relevant right after returning to main following a merged PR.
---

Follow `.ai/task-workflow.md → Agentic Git Collaboration Workflow` (local branch cleanup):

1. List local branches other than `main`/`master`.
2. Do NOT rely on `git branch --merged` or any local ancestry check. This kit assumes squash-merge (`docs/06-repo-settings.md`), and a squash-merged branch's commits never become ancestors of `main` — ancestry checks produce false negatives. The containment check in step 5 does not care which strategy was used, so there is no merge strategy to confirm first.
3. Do NOT trust the git provider's `merged`/`state` API fields as the primary signal either. These have been observed to misreport `merged: false` for PRs that were demonstrably merged. Treat them as, at best, a secondary cross-check — never as the deciding signal.
4. Do NOT decide on PR-title matching either. Squash-merge does use the PR title as the commit message, but that title is routinely edited on the way in: the provider appends ` (#N)`, and maintainers retitle at merge time. Both are ordinary actions, and either one breaks an exact match on a branch that was genuinely merged. Titles are useful for naming the PR in your report, never for deciding.
5. Primary detection method: containment. The question is not whether some string matches, it is whether the branch still carries anything `main` lacks — ask git directly (requires git ≥ 2.38):

   ```sh
   git merge-tree --write-tree main <branch>   # prints the merged tree OID
   git rev-parse main^{tree}                   # main's own tree OID
   ```

   Equal OIDs mean merging the branch into `main` would change nothing: every change it carries is already there, so it is safe to delete. Differing OIDs, or a non-zero exit (conflict), mean it still carries unmerged content — leave it alone. This is authoritative regardless of merge strategy, of how far `main` has moved since the merge, and of any title editing. It writes objects only: no refs, index, or working tree are touched.

6. Do NOT substitute `git diff main <branch>` for step 5. It proves containment only while empty, and it stops being empty as soon as `main` gains any unrelated commit — reporting a long-merged branch as unmerged.
7. Only delete a local branch once step 5 confirms containment. `git branch -d` refuses squash-merged branches by design (their commits are not ancestors of `main`), so an explicit `git branch -D` is expected here — but only after that confirmation, never based on an API field, a title, or an assumption.
8. Leave alone: `main`/`master`, any branch with no corresponding PR found, and any branch step 5 does not confirm as contained (still open, closed without merging, or carrying local work).
9. Report exactly which branches were deleted and which were left alone, with the reason for each. Note any signal that disagreed with the containment result — an API field claiming `merged`, or a title that did or didn't match — since a disagreement usually means something happened at merge time worth knowing about.

Deleting a branch is irreversible from the user's point of view, so confirm before deleting anything step 5 could not positively prove was contained. Reporting an unconfirmed branch and leaving it is always the correct outcome — never a failure.

Do not restate this procedure elsewhere — `.ai/task-workflow.md` is the single source of truth, shared with any other agent tool used on this repo.
