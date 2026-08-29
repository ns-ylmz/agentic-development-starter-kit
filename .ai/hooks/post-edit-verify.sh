#!/bin/bash
# Destination in a new project: .ai/hooks/post-edit-verify.sh
# Wired from: agent tool configs (PostToolUse, matcher: "Write|Edit")
#
# Runs eslint on the file just touched and feeds the result back into
# context as additionalContext. Non-blocking by design: surfaces issues
# immediately after each edit instead of waiting until commit time, without
# interrupting the agent loop. Only useful in projects that use eslint; it
# no-ops harmlessly (no eslint config, `npx` fails silently into an empty
# lint output) in projects that don't.

set -euo pipefail

INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

[ -z "$FILE" ] && exit 0

case "$FILE" in
  *.ts|*.tsx|*.js|*.jsx) ;;
  *) exit 0 ;;
esac

[ -f "$FILE" ] || exit 0

LINT_OUTPUT=$(cd "." && npx --no-install eslint --no-error-on-unmatched-pattern "$FILE" 2>&1 || true)

if [ -n "$LINT_OUTPUT" ]; then
  jq -n --arg ctx "$LINT_OUTPUT" '{
    hookSpecificOutput: {
      hookEventName: "PostToolUse",
      additionalContext: ("eslint output for the file just edited:\n" + $ctx)
    }
  }'
fi

exit 0
