#!/bin/bash
# Destination in a new project: .ai/hooks/guard-pr-body.sh
# Wired from: .claude/settings.json (PreToolUse, matcher for any
# "pull_request_create" tool from any MCP git provider server, e.g.
# mcp__GitKraken__pull_request_create, mcp__github__create_pull_request —
# use a regex matcher like `mcp__.*__pull_request_create`).
#
# Denies PR creation unless the body contains every top-level (##) section
# header found in the current project's own .github/pull_request_template.md.
# Headers are read dynamically — nothing is hardcoded — so this same script
# works unmodified in any project, and simply allows silently in projects
# that don't have a template file yet.
#
# Requires: a .github/pull_request_template.md in the target project with
# at least one "## Section Name" header. Without one, this hook is a no-op.

set -euo pipefail

INPUT=$(cat)
BODY=$(echo "$INPUT" | jq -r '.tool_input.body // empty')
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
TEMPLATE="$PROJECT_DIR/.github/pull_request_template.md"

# No template in this project: nothing to enforce.
[ -f "$TEMPLATE" ] || exit 0

deny() {
  jq -n --arg reason "$1" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $reason
    }
  }'
  exit 0
}

REQUIRED_HEADERS=$(grep -E '^##[[:space:]]+' "$TEMPLATE" | sed -E 's/^##[[:space:]]+//')

# Template has no ## sections to check against: nothing to enforce.
[ -n "$REQUIRED_HEADERS" ] || exit 0

if [ -z "$BODY" ]; then
  deny "PR body is empty. Read .github/pull_request_template.md and populate the PR description using its structure before creating the PR."
fi

MISSING=""
while IFS= read -r header; do
  [ -z "$header" ] && continue
  echo "$BODY" | grep -qiF "## ${header}" || MISSING="${MISSING}\"${header}\" "
done <<< "$REQUIRED_HEADERS"

if [ -n "$MISSING" ]; then
  deny "PR body is missing required section(s) from .github/pull_request_template.md: ${MISSING}. Use its exact structure instead of a freeform body."
fi

exit 0
