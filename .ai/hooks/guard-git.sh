#!/bin/bash
# Destination in a new project: .ai/hooks/guard-git.sh
# Wired from: agent tool configs (PreToolUse, matcher: "Bash")
#
# Default git guardrails (plain bash + jq):
#   - no direct commits to main/master
#   - no force-push
#   - no committing secret/env files
#
# Reads the Bash tool_input JSON on stdin. Exits 0 with no output when the
# command is allowed. Prints a deny decision when a guardrail is violated.

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

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

# Only inspect actual git invocations.
if ! echo "$COMMAND" | grep -qE '(^|[;&|]\s*)git\b'; then
  exit 0
fi

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")

# 1. No direct commits on main/master.
if echo "$COMMAND" | grep -qE '(^|[;&|]\s*)git\s+commit\b' \
   && { [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ]; }; then
  deny "Feature work should not be committed directly on ${CURRENT_BRANCH}. Create a task branch first."
fi

# 2. No force-push.
if echo "$COMMAND" | grep -qE '(^|[;&|]\s*)git\s+push\b' \
   && echo "$COMMAND" | grep -qE -- '(--force\b|--force-with-lease\b|\s-f\b)'; then
  deny "Force-push is blocked, including when the user asked for it: this hook sees only the command, not the conversation. Prepare and verify the branch locally, then give the user the exact command to run themselves. Do not wrap the push in a script or alias to get around this."
fi

# 3. No committing secret/env files.
if echo "$COMMAND" | grep -qE '(^|[;&|]\s*)git\s+commit\b'; then
  STAGED=$(git diff --cached --name-only 2>/dev/null || echo "")
  # Committed placeholder templates carry no secrets and are meant to be
  # checked in (e.g. .env.example); exclude them before matching.
  SECRET_CANDIDATES=$(echo "$STAGED" | grep -vE '(^|/)\.env\.(example|sample|template|defaults)$')
  if echo "$SECRET_CANDIDATES" | grep -qE '(^|/)\.env(\..*)?$|\.pem$|\.key$|(^|/)id_rsa$|(^|/)\.npmrc$'; then
    MATCHES=$(echo "$SECRET_CANDIDATES" | grep -E '(^|/)\.env(\..*)?$|\.pem$|\.key$|(^|/)id_rsa$|(^|/)\.npmrc$' | tr '\n' ' ')
    deny "Staged changes include a secret/env-looking file (${MATCHES}). Unstage it before committing."
  fi
fi

exit 0
