#!/bin/bash
# Destination in a new project: .claude/hooks/suggest-branch-cleanup.sh
# Wired from: .claude/settings.json (PostToolUse, matcher: "Bash")
#
# NON-BLOCKING. Surfaces context and never fails a tool call.
#
# Fires after every Bash command; only acts when the command looks like
# returning to main/master via checkout. It never deletes branches itself:
# reliably detecting whether a branch is already merged requires reading PR
# state from the git provider (this kit assumes squash-merge, which breaks
# local ancestry checks like `git branch --merged`), and a plain shell hook
# has no provider credentials of its own. It defers that judgment to the
# cleanup-merged-branches skill, which runs at the agent level with access
# to the connected git provider's tools.

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

echo "$COMMAND" | grep -qE 'git[[:space:]]+(checkout|switch)[[:space:]]+(main|master)\b' || exit 0

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
{ [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ]; } || exit 0

OTHER_BRANCHES=$(git branch --format='%(refname:short)' | grep -vE '^(main|master)$' || true)
COUNT=$(echo "$OTHER_BRANCHES" | grep -c . || true)

[ "$COUNT" -gt 0 ] || exit 0

BRANCH_LIST=$(echo "$OTHER_BRANCHES" | tr '\n' ' ' | sed 's/[[:space:]]*$//')

jq -n --arg ctx "There are $COUNT local branch(es) besides main/master: $BRANCH_LIST. Some may already be merged (including via squash-merge, which local ancestry checks won't detect). Consider running the cleanup-merged-branches skill to check each against the git provider's PR state and delete the ones confirmed merged." '{
  hookSpecificOutput: {
    hookEventName: "PostToolUse",
    additionalContext: $ctx
  }
}'
