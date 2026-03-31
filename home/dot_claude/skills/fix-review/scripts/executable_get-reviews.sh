#!/bin/bash
set -euo pipefail

read -r PR_NUMBER REPO_OWNER REPO_NAME < <(
	gh pr view --json number,headRepository,headRepositoryOwner |
		jq -r '[.number, .headRepositoryOwner.login, .headRepository.name] | @tsv'
)

readonly GRAPHQL_QUERY='
query($owner: String!, $repo: String!, $number: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $number) {
      reviewThreads(first: 100) {
        nodes {
          isResolved
          path
          line
          comments(first: 100) {
            nodes {
              id
              databaseId
              author { __typename login }
              body
              createdAt
            }
          }
        }
      }
    }
  }
}
'

readonly JQ_FORMAT='
def time_fmt:
  split("T") as $p
  | ($p[0] | split("-") | "\(.[1] | tonumber)/\(.[2] | tonumber)") as $d
  | ($p[1] | split(":")[0:2] | join(":"))
  | "\($d) \(.)";


.data.repository.pullRequest.reviewThreads.nodes[] |
select(.comments.nodes | length > 0) |
{
  is_resolved: .isResolved,
  file: .path,
  line: .line,
  comments: [.comments.nodes[] | {
    id: .databaseId,
    user: .author.login,
    is_bot: ((.author.__typename == "Bot") or (.author.login | test("\\[bot\\]$"))),
    body: .body,
    created_at: .createdAt,
    time_fmt: (.createdAt | time_fmt)
  }]
} |
(if .is_resolved then "✅ [解決済]" else "❌ [未解決]" end) + " 📁 \(.file):\(.line)",
"",
(.comments | to_entries[] |
  (.key) as $k
  | (if $k > 0 then "──" else "" end),
  ("#\($k + 1)" as $num
  | "\($num) \(if .value.is_bot then "🤖 " else "👤 " end)\(.value.user)\(if .value.is_bot then " 【bot】" else "" end) [\(.value.time_fmt)]\(if $k > 0 then " (返信)" else "" end):"),
  (.value.body | split("\n") | join("\n")),
  ""
),
"---",
""
'

RESULT=$(gh api graphql \
	-f query="$GRAPHQL_QUERY" \
	-f owner="$REPO_OWNER" \
	-f repo="$REPO_NAME" \
	-F number="$PR_NUMBER")

echo "$RESULT" | jq -r "$JQ_FORMAT"
