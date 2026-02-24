#!/usr/bin/env bash
#
# Stop hook: Verify tests pass before Claude considers itself done.
#
# This is a COMMAND-based stop hook (not prompt-based). It checks whether
# the test suite was run and passed during the current session by inspecting
# the conversation transcript for test output patterns.
#
# Usage in settings.json:
# {
#   "hooks": {
#     "Stop": [
#       {
#         "hooks": [
#           {
#             "type": "command",
#             "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/stop-verify-tests.sh",
#             "timeout": 10
#           }
#         ]
#       }
#     ]
#   }
# }
#
# How it works:
# - Reads the conversation transcript from stdin (provided by Claude Code)
# - Searches for evidence that tests were run and passed
# - Exits 0 (allow stop) if tests passed, exits 2 (block stop) with a message if not
#
# Customize the PASS_PATTERNS array for your test framework's success output.

set -euo pipefail

# Patterns that indicate tests passed (add your framework's patterns)
PASS_PATTERNS=(
  "Tests:.*passed"          # Jest
  "passing"                 # Mocha
  "passed"                  # Playwright
  "OK ("                    # PHPUnit
  "tests? passed"           # Generic
  "All specs passed"        # Cypress
  "PASSED"                  # pytest
)

# Read conversation transcript from stdin
TRANSCRIPT=$(cat)

# Check if any pass pattern is found
for pattern in "${PASS_PATTERNS[@]}"; do
  if echo "$TRANSCRIPT" | grep -qiE "$pattern"; then
    exit 0  # Tests passed, allow stop
  fi
done

# No evidence of passing tests found
echo "Tests don't appear to have been run and passed in this session. Please run the test suite before finishing."
exit 2  # Block stop with reason
