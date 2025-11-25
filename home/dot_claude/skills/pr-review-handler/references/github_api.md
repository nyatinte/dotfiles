# PRレビュー用GitHub APIリファレンス

## GraphQL APIエンドポイント

### Unresolvedレビュースレッドの取得

プルリクエストのすべてのunresolvedレビュースレッドを取得するクエリ:

```graphql
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
```

**主要フィールド:**
- `id`: スレッドID
- `isResolved`: スレッドがresolve済みかどうか
- `isOutdated`: スレッドが古くなっているか(コードが変更された)
- `comments`: スレッド内のコメント配列
- `databaseId`: 数値のコメントID
- `path`: コメントのファイルパス
- `line`: 行番号
- `diffHunk`: コメント周辺のdiffコンテキスト

## gh CLIの使用方法

### GraphQLクエリの実行

```bash
gh api graphql -f owner="$OWNER" -f repo="$REPO" -F pr="$PR_NUMBER" -f query='<graphql-query>'
```

## 重要な注意事項

- クエリごとに最大100個のレビュースレッド(それ以上はページネーション必要)
- スレッドIDは不透明な文字列で、数値ではない
- unresolvedコメントを取得するには必ず`isResolved: false`でフィルタ
- 古いコメントをスキップするには`isOutdated`も確認を検討
