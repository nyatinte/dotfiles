#!/bin/bash
# Get unresolved review threads for a pull request
# Usage: ./get_unresolved_reviews.sh <owner> <repo> <pr_number>

set -euo pipefail

if [ $# -ne 3 ]; then
    echo "Usage: $0 <owner> <repo> <pr_number>" >&2
    exit 1
fi

OWNER="$1"
REPO="$2"
PR_NUMBER="$3"

gh api graphql -f owner="$OWNER" -f repo="$REPO" -F pr="$PR_NUMBER" -f query='
  query FetchUnresolvedReviewThreads($owner: String!, $repo: String!, $pr: Int!) {
    repository(owner: $owner, repo: $repo) {
      pullRequest(number: $pr) {
        reviewThreads(first: 100) {
          nodes {
            id
            isResolved
            isOutdated
            comments(first: 100) {
              nodes {
                id
                databaseId
                path
                body
                author {
                  login
                }
                createdAt
                line
                startLine
                diffHunk
              }
            }
          }
        }
      }
    }
  }
' | jq -c '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)'
