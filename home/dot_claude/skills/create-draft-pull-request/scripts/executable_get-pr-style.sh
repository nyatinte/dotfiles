#!/bin/bash
# Usage: get-pr-style.sh [limit]
# Fetches recent merged PRs and their bodies for style reference.

set -e

LIMIT="${1:-5}"

echo "=== Recent Merged PRs ==="
gh pr list --author @me --state merged --limit "$LIMIT" --json number,title,url
echo ""

echo "=== PR Body Samples ==="
PR_NUMBERS=$(gh pr list --author @me --state merged --limit 3 --json number --jq '.[].number')
for NUM in $PR_NUMBERS; do
  echo "--- PR #${NUM} ---"
  gh pr view "$NUM" --json title,body --jq '"Title: " + .title + "\n\nBody:\n" + .body'
  echo ""
done
