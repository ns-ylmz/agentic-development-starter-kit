#!/bin/bash
# Destination in a new project: .claude/hooks/remind-return-to-main.sh
# Wired from: .claude/settings.json (PostToolUse, matchers: "Bash" and
# "mcp__.*__pull_request_create" — the regex catches any MCP git provider
# server, e.g. mcp__GitKraken__pull_request_create,
# mcp__github__create_pull_request).
#
# NON-BLOCKING. Surfaces context and never fails a tool call.
#
# .ai/task-workflow.md -> "Agentic Git Collaboration Workflow" step 10
# recommends returning the local working directory to an up-to-date main
# branch (without deleting the just-opened task branch) once a PR is open.
# That's a recommended habit, not a hard gate, so this hook only nudges
# after a PR-creation tool call; it does not verify that the agent complies.
#
# Covers both PR-creation paths, mirroring guard-pr-body.sh:
#   - Bash: a `gh pr create` invocation. Any other Bash command is ignored.
#   - MCP: a "pull_request_create"-style tool call, which carries no
#     command field, so its absence is what identifies this path.
#
# The Bash pattern is anchored to the start of a command (like guard-git.sh)
# so that merely mentioning `gh pr create` — grepping for it, echoing it,
# writing it into a doc — doesn't fire a spurious nudge.

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Bash path: nudge only for `gh pr create`. MCP path: no command field at
# all, and the matcher already guarantees it was a PR creation.
if [ -n "$COMMAND" ]; then
  echo "$COMMAND" | grep -qE '(^|[;&|][[:space:]]*)gh[[:space:]]+pr[[:space:]]+create\b' || exit 0
fi

jq -n '{
  hookSpecificOutput: {
    hookEventName: "PostToolUse",
    additionalContext: "A pull request was just created. Per .ai/task-workflow.md, consider returning the local working directory to an up-to-date main branch (git checkout main && git pull --ff-only origin main) without deleting the just-opened task branch. This is a recommended habit, not a hard requirement."
  }
}'
