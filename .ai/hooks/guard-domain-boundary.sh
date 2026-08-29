#!/bin/bash
# Destination in a new project: .ai/hooks/guard-domain-boundary.sh
# Wired from: agent tool configs (PreToolUse, matcher: Edit|Write|MultiEdit).
#
# Turns the domain-boundary docs (.ai/*-domain-boundaries.md) from
# prompt-level guidance into an enforced invariant for domain-scoped
# implementer subagents (.ai/agents/): an implementer subagent is denied
# any Edit/Write/MultiEdit under path fragments it does not own.
#
# The boundary map below is the only project-specific part. Each line is:
#   <agent-name>|<forbidden-path-fragment>[|<forbidden-path-fragment>...]
# Add or remove lines to match the project's subagents and layout. Paths not
# listed for an agent stay unrestricted (shared packages, docs, root config
# are intentionally editable by every agent).
#
# Only fires when agent_type identifies a mapped subagent (present in the
# hook input whenever the tool call originates from inside a subagent). The
# main conversation and every unmapped subagent are unaffected.
#
# Plain bash + jq, reading the agent_type/tool_input fields from the hook input.

set -euo pipefail

# --- Project boundary map (edit per project) --------------------------------
BOUNDARY_MAP="
backend-implementer|apps/frontend/
frontend-implementer|apps/backend/
"
# -----------------------------------------------------------------------------

INPUT=$(cat)
AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // empty')

# Not running inside a subagent: nothing to enforce here.
[ -n "$AGENT_TYPE" ] || exit 0

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
[ -n "$FILE_PATH" ] || exit 0

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

while IFS= read -r line; do
  [ -z "$line" ] && continue
  AGENT="${line%%|*}"
  [ "$AGENT" = "$AGENT_TYPE" ] || continue

  FRAGMENTS="${line#*|}"
  IFS='|' read -ra PARTS <<< "$FRAGMENTS"
  for FRAGMENT in "${PARTS[@]}"; do
    [ -z "$FRAGMENT" ] && continue
    case "$FILE_PATH" in
      *"$FRAGMENT"*)
        deny "domain-boundaries: ${AGENT_TYPE} can't edit ${FRAGMENT}** (${FILE_PATH}). Delegate this change to the subagent that owns it, or to the main conversation."
        ;;
    esac
  done
done <<< "$BOUNDARY_MAP"

exit 0
