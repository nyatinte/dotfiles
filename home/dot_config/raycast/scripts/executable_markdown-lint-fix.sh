#!/bin/bash -l

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Markdown Lint Fix
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon ✅
# @raycast.packageName Writing Tools

# Documentation:
# @raycast.description Fix clipboard Markdown with markdownlint then textlint (autofix only)

tmp_file=$(mktemp /tmp/raycast-lint-XXXXXX.md)
trap "rm -f $tmp_file" EXIT

pbpaste > "$tmp_file"

markdownlint-cli2 --fix "$tmp_file" 2>/dev/null || true
textlint --fix "$tmp_file" 2>/dev/null || true

cat "$tmp_file"
