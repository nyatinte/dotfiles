#!/bin/bash
# Usage: push-and-create-pr.sh <base-branch> [pr-md-path]
# Reads title from line 1 of PR.md, body from remaining lines.
# Outputs the created PR URL on success.

set -e

BASE_BRANCH="${1:?base-branch is required}"
PR_MD="${2:-PR.md}"

CURRENT_BRANCH=$(git branch --show-current)
TITLE=$(head -n1 "$PR_MD")
BODY=$(tail -n+2 "$PR_MD")

git push -u origin "$CURRENT_BRANCH"

gh pr create \
  --base "$BASE_BRANCH" \
  --title "$TITLE" \
  --body "$BODY" \
  --draft
