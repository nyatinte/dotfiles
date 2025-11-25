#!/bin/bash
# Resolve a review thread
# Usage: ./resolve_thread.sh <thread_id>

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <thread_id>" >&2
    exit 1
fi

THREAD_ID="$1"

gh api graphql -f threadId="$THREAD_ID" -f query='
  mutation($threadId: ID!) {
    resolveReviewThread(input: {threadId: $threadId}) {
      thread {
        id
        isResolved
      }
    }
  }
'
