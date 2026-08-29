# Repository Settings

The local hooks and `.ai/guidelines/workflow.md` assume these server-side settings. Apply them when creating the repository — they are the part of the policy that cannot ship as files.

## Branch Protection (`main`)

- Require a pull request before merging; no direct pushes.
- Require the CI status checks (`verify`, `commitlint`, `pr-template` from `.github/workflows/ci.yml`) to pass.
- Dismiss stale approvals on new commits.
- Do not allow force pushes or deletions.

## Merge Strategy

- Squash-and-merge only. The PR title becomes the squash commit message, so PR titles must follow Conventional Commits (commitlint's `type-enum`). This is also what makes merged-branch detection reliable (see `.ai/guidelines/workflow.md → Agentic Git Collaboration Workflow`).

## Housekeeping

- Enable "Automatically delete head branches".
- Set the repository description and default branch to `main`.

## Review

- Require at least one approving review (adjust to team size).
- Optionally add a `CODEOWNERS` file to route domain-specific reviews.
