#!/bin/bash

# Document checker script using textlint
# Usage: check_document.sh <file_path>

if [ $# -eq 0 ]; then
    echo "Error: No file path provided"
    echo "Usage: check_document.sh <file_path>"
    exit 1
fi

FILE_PATH="$1"

if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File not found: $FILE_PATH"
    exit 1
fi

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$SKILL_DIR/assets/.textlintrc"

# Check if textlint is installed
if ! command -v textlint &> /dev/null; then
    echo "Error: textlint is not installed globally"
    echo "Please install textlint and presets:"
    echo "  npm install -g textlint @textlint-ja/textlint-rule-preset-ai-writing textlint-rule-preset-ja-spacing"
    exit 1
fi

# Run textlint with the configuration
textlint --config "$CONFIG_FILE" "$FILE_PATH"
