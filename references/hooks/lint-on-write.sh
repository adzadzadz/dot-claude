#!/bin/bash
# Hook: Auto-lint after Claude writes or edits files
# Type: PostToolUse (matcher: Write|Edit)
#
# This hook runs the project's linter after Claude modifies a file.
# It reads the tool result from stdin to get the file path, then runs
# the appropriate linter based on file extension.
#
# Setup in .claude/settings.json:
# {
#   "hooks": {
#     "PostToolUse": [
#       {
#         "matcher": "Write|Edit",
#         "hooks": [
#           {
#             "type": "command",
#             "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/lint-on-write.sh",
#             "timeout": 30
#           }
#         ]
#       }
#     ]
#   }
# }

# Read the tool result from stdin to get the file path
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.filePath // empty' 2>/dev/null)

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Get file extension
EXT="${FILE_PATH##*.}"

# Run the appropriate linter based on extension
case "$EXT" in
  js|jsx|ts|tsx)
    if command -v npx &> /dev/null && [ -f "node_modules/.bin/eslint" ]; then
      npx eslint --fix "$FILE_PATH" 2>&1
    elif command -v npx &> /dev/null && [ -f "node_modules/.bin/prettier" ]; then
      npx prettier --write "$FILE_PATH" 2>&1
    fi
    ;;
  py)
    if command -v ruff &> /dev/null; then
      ruff check --fix "$FILE_PATH" 2>&1
      ruff format "$FILE_PATH" 2>&1
    elif command -v black &> /dev/null; then
      black "$FILE_PATH" 2>&1
    fi
    ;;
  php)
    if command -v php &> /dev/null; then
      php -l "$FILE_PATH" 2>&1
    fi
    ;;
  *)
    # No linter for this extension
    exit 0
    ;;
esac
