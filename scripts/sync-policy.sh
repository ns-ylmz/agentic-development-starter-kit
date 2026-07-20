#!/usr/bin/env bash
#
# sync-policy.sh — propagate this kit's canonical Claude policy to a downstream
# repo as a reviewed pull request.
#
# This kit is the single upstream source of truth for the paths listed in
# policy-manifest.txt. Workflow: edit a canonical file HERE, merge it, then run
# this against each downstream repo. Only manifest-listed files are touched;
# project-owned files are never overwritten. Every change lands as a PR you
# review before merging — nothing is pushed to a downstream's default branch.
#
# Usage:
#   scripts/sync-policy.sh <target-repo-path> [options]
#
# Options:
#   --dry-run          Show what would change; make no edits, no git, no PR.
#   --no-pr            Copy + commit + push the branch, but don't open a PR.
#   --branch <name>    Override the sync branch name.
#   -h, --help         Show this help.
#
# Notes:
#   - Run this in your own terminal (not inside a Claude session bound to a
#     different repo), so the TARGET repo's own git guardrails apply.
#   - The target working tree must be clean.
#   - Requires: git, and (unless --no-pr/--dry-run) the GitHub CLI `gh`.

set -euo pipefail

KIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="$KIT_ROOT/policy-manifest.txt"

usage() { sed -n '2,30p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit "${1:-1}"; }
die() { echo "error: $*" >&2; exit 1; }

TARGET=""; DRY_RUN=0; MAKE_PR=1; BRANCH=""
while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --no-pr)   MAKE_PR=0; shift ;;
    --branch)  BRANCH="${2:-}"; [ -n "$BRANCH" ] || die "--branch needs a value"; shift 2 ;;
    -h|--help) usage 0 ;;
    -*)        die "unknown option: $1" ;;
    *)         [ -z "$TARGET" ] || die "unexpected extra argument: $1"; TARGET="$1"; shift ;;
  esac
done

[ -n "$TARGET" ] || usage
[ -f "$MANIFEST" ] || die "manifest not found: $MANIFEST"
TARGET="$(cd "$TARGET" 2>/dev/null && pwd)" || die "target path not found: $TARGET"
git -C "$TARGET" rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "not a git repo: $TARGET"

KIT_SHA="$(git -C "$KIT_ROOT" rev-parse --short HEAD)"

# Read manifest: drop blank lines and comments.
PATHS=()
while IFS= read -r line; do
  case "$line" in ''|\#*) continue ;; esac
  PATHS+=("$line")
done < "$MANIFEST"
[ ${#PATHS[@]} -gt 0 ] || die "manifest lists no paths"

# Determine which files differ (would change) without writing anything yet.
CHANGED=()
for p in "${PATHS[@]}"; do
  src="$KIT_ROOT/$p"
  [ -f "$src" ] || { echo "WARN: manifest path missing in kit, skipping: $p" >&2; continue; }
  dst="$TARGET/$p"
  if [ ! -f "$dst" ] || ! diff -q "$src" "$dst" >/dev/null 2>&1; then
    CHANGED+=("$p")
  fi
done

if [ ${#CHANGED[@]} -eq 0 ]; then
  echo "Already in sync with kit @ $KIT_SHA — nothing to do."
  exit 0
fi

echo "Kit @ $KIT_SHA → $TARGET"
echo "Would update ${#CHANGED[@]} file(s):"
printf '  %s\n' "${CHANGED[@]}"

if [ "$DRY_RUN" -eq 1 ]; then
  echo "(dry run — no changes made)"
  exit 0
fi

# From here on we mutate the target repo. Require a clean tree first.
git -C "$TARGET" diff --quiet && git -C "$TARGET" diff --cached --quiet \
  || die "target working tree is not clean; commit or stash first: $TARGET"

# Base the sync on the target's up-to-date default branch.
DEFAULT_BRANCH="$(git -C "$TARGET" symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##')"
DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"
BRANCH="${BRANCH:-chore/policy-sync-$KIT_SHA}"

git -C "$TARGET" fetch --quiet origin "$DEFAULT_BRANCH"
git -C "$TARGET" checkout --quiet "$DEFAULT_BRANCH"
git -C "$TARGET" pull --quiet --ff-only origin "$DEFAULT_BRANCH"
git -C "$TARGET" checkout -B "$BRANCH"

# Copy the changed canonical files in.
for p in "${CHANGED[@]}"; do
  mkdir -p "$TARGET/$(dirname "$p")"
  cp "$KIT_ROOT/$p" "$TARGET/$p"
done

git -C "$TARGET" add -- "${CHANGED[@]}"
git -C "$TARGET" commit -m "chore(policy): sync canonical .claude/.ai from starter kit @ $KIT_SHA" \
  -m "Synced from claude-code-policy-starter ($KIT_SHA) via scripts/sync-policy.sh. Only policy-manifest.txt paths are touched."
git -C "$TARGET" push -u origin "$BRANCH"

if [ "$MAKE_PR" -eq 0 ]; then
  echo "Pushed $BRANCH. Skipping PR (--no-pr)."
  exit 0
fi

command -v gh >/dev/null 2>&1 || die "gh CLI not found; re-run with --no-pr and open the PR manually."

BODY="$(mktemp)"
{
  echo "## Objective"
  echo
  echo "Sync canonical Claude policy files (\`.claude/\`, \`.ai/\`) from the claude-code-policy-starter kit (\`$KIT_SHA\`). The kit is the single upstream source of truth for these paths; only files listed in its \`policy-manifest.txt\` are updated, and project-owned files are left untouched."
  echo
  echo "## Scope & Changed Areas"
  echo
  for p in "${CHANGED[@]}"; do echo "- \`$p\`"; done
  echo
  echo "## Verification"
  echo
  echo "- [x] Task constraints maintained? (only manifest-listed canonical files changed)"
  echo "- [x] Bounded scope preserved? (paths limited to policy-manifest.txt)"
  echo "- [ ] Diff reviewed before merge (confirm no project-specific override was clobbered)"
} > "$BODY"

# gh has no global -C; detect the repo from the target's origin and pass --repo.
TARGET_REPO="$(git -C "$TARGET" remote get-url origin | sed -E 's#(git@github.com:|https://github.com/)##; s#\.git$##')"
( cd "$TARGET" && gh pr create \
    --repo "$TARGET_REPO" \
    --base "$DEFAULT_BRANCH" --head "$BRANCH" \
    --title "chore(policy): sync canonical .claude/.ai from starter kit @ $KIT_SHA" \
    --body-file "$BODY" )
rm -f "$BODY"
