#!/bin/bash
# Destination in a new project: .ai/hooks/guard-pr-body.sh
# Wired from: agent tool configs (PreToolUse, matchers: "Bash" and
# "mcp__.*__pull_request_create" — the regex catches any MCP git provider
# server, e.g. mcp__GitKraken__pull_request_create,
# mcp__github__create_pull_request).
#
# Denies PR creation unless the body contains every top-level (##) section
# header found in the current project's own .github/pull_request_template.md.
#
# Handles both PR-creation paths:
#   - Bash: a `gh pr create` invocation. The body is read from --body-file,
#     or otherwise from the raw command text itself (an inline --body value
#     or a heredoc is already present verbatim in the command string before
#     the shell expands it, so checking the command text directly works).
#   - MCP: a "pull_request_create"-style tool call, where tool_input.body
#     is a direct JSON field.
#
# Headers are read dynamically — nothing is hardcoded — so this same script
# works unmodified in any project, and simply allows silently in projects
# that don't have a template file yet.
#
# Plain bash + jq; no external dependencies beyond the gh CLI conventions.

set -euo pipefail

INPUT=$(cat)
TEMPLATE=".github/pull_request_template.md"

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

missing_headers() {
  local body="$1"
  local missing=""
  while IFS= read -r header; do
    [ -z "$header" ] && continue
    echo "$body" | grep -qiF "## ${header}" || missing="${missing}\"${header}\" "
  done <<< "$REQUIRED_HEADERS"
  echo "$missing"
}

COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [ -n "$COMMAND" ]; then
  # Bash tool call: only guard actual `gh pr create` invocations.
  echo "$COMMAND" | grep -qE '(^|[;&|]\s*)gh\s+pr\s+create\b' || exit 0

  BODY_FILE=$(echo "$COMMAND" | grep -oE -- '--body-file[= ]+[^ ]+' | head -1 || true)
  BODY_FILE="${BODY_FILE#--body-file}"
  BODY_FILE="${BODY_FILE#=}"
  BODY_FILE="${BODY_FILE# }"

  if [ -n "$BODY_FILE" ]; then
    case "$BODY_FILE" in
      /*) BODY_FILE_PATH="$BODY_FILE" ;;
      *) BODY_FILE_PATH="$BODY_FILE" ;;
    esac
    if [ ! -f "$BODY_FILE_PATH" ]; then
      deny "gh pr create --body-file points at a file that doesn't exist yet (${BODY_FILE}). Write the PR body file first."
    fi
    BODY=$(cat "$BODY_FILE_PATH")
  else
    echo "$COMMAND" | grep -qE -- '--body\b' \
      || deny "gh pr create has no --body/--body-file. Read .github/pull_request_template.md and populate the PR description using its exact structure before creating the PR."
    # Inline or heredoc body: the literal text is already present in the
    # command string before the shell expands it, so check the raw command.
    BODY="$COMMAND"
  fi
else
  # MCP-style tool call: tool_input.body is a direct JSON field.
  BODY=$(echo "$INPUT" | jq -r '.tool_input.body // empty')

  if [ -z "$BODY" ]; then
    deny "PR body is empty. Read .github/pull_request_template.md and populate the PR description using its exact structure before creating the PR."
  fi
fi

MISSING=$(missing_headers "$BODY")

if [ -n "$MISSING" ]; then
  deny "PR body is missing required section(s) from .github/pull_request_template.md: ${MISSING}. Use its exact structure instead of a freeform body."
fi

exit 0
