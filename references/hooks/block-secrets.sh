#!/bin/bash
# Hook: Block Claude from reading credential files
# Type: PreToolUse (matcher: Read|Bash)
#
# This hook prevents Claude from reading files that likely contain secrets.
# It checks the tool input for sensitive file patterns and blocks the action.
#
# Setup in .claude/settings.json:
# {
#   "hooks": {
#     "PreToolUse": [
#       {
#         "matcher": "Read|Bash",
#         "hooks": [
#           {
#             "type": "command",
#             "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/block-secrets.sh",
#             "timeout": 10
#           }
#         ]
#       }
#     ]
#   }
# }

# Read the tool input from stdin
INPUT=$(cat)

# Extract the relevant path or command
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)
FILE_PATH=""
COMMAND=""

if [ "$TOOL_NAME" = "Read" ]; then
  FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.filePath // empty' 2>/dev/null)
elif [ "$TOOL_NAME" = "Bash" ]; then
  COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)
fi

# Patterns that indicate credential/secret files
BLOCKED_PATTERNS=(
  ".env"
  ".env.local"
  ".env.production"
  ".env.staging"
  "credentials"
  "secrets"
  "wp-config.php"
  ".npmrc"
  ".pypirc"
  "id_rsa"
  "id_ed25519"
  ".pem"
  "notes.txt"
)

# Check file path for Read tool
if [ -n "$FILE_PATH" ]; then
  BASENAME=$(basename "$FILE_PATH")
  for PATTERN in "${BLOCKED_PATTERNS[@]}"; do
    if [[ "$BASENAME" == *"$PATTERN"* ]] || [[ "$FILE_PATH" == *"/secrets/"* ]]; then
      echo '{"ok": false, "reason": "Blocked: This file likely contains credentials. If you need access, ask the user to provide the specific values you need."}'
      exit 0
    fi
  done
fi

# Check bash commands for cat/head/tail of sensitive files
if [ -n "$COMMAND" ]; then
  for PATTERN in "${BLOCKED_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -qE "(cat|head|tail|less|more|vi|vim|nano|bat)\s.*$PATTERN"; then
      echo '{"ok": false, "reason": "Blocked: This command would read a file that likely contains credentials."}'
      exit 0
    fi
  done
fi

# Allow the action
exit 0
