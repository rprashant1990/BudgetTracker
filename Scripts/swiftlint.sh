#!/bin/sh
# SwiftLint Run Script for BudgetTracker
# Usage:
#   - Lint only:        Scripts/swiftlint.sh
#   - Autocorrect + lint: SWIFTLINT_AUTOCORRECT=1 Scripts/swiftlint.sh
#
# Add this script to your Xcode target as a Run Script Build Phase:
#   - Shell: /bin/sh
#   - Script: ${PROJECT_DIR}/Scripts/swiftlint.sh
#   - Place before "Compile Sources"

/opt/homebrew/bin/swiftlint
set -euo pipefail

# Resolve swiftlint binary
if command -v swiftlint >/dev/null 2>&1; then
  SWIFTLINT_BIN=$(command -v swiftlint)
else
  echo "warning: SwiftLint not installed. Install with 'brew install swiftlint' or add it to your PATH."
  exit 0
fi

# Respect repo-root config if present
CONFIG_FILE="${PROJECT_DIR}/.swiftlint.yml"
CONFIG_ARG=""
if [ -f "$CONFIG_FILE" ]; then
  CONFIG_ARG="--config \"$CONFIG_FILE\""
fi

# Optionally run autocorrect first (opt-in)
if [ "${SWIFTLINT_AUTOCORRECT-0}" = "1" ]; then
  echo "Running SwiftLint autocorrect…"
  eval "$SWIFTLINT_BIN autocorrect --quiet $CONFIG_ARG" || true
fi

# Always run lint, report in Xcode format
echo "Running SwiftLint…"
eval "$SWIFTLINT_BIN lint --quiet $CONFIG_ARG"
