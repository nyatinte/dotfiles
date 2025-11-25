---
allowed-tools: Bash(gh pr view:*), Bash(gh pr list:*), Bash(gh api graphql:*), Bash(gh api repos/*/pulls/*/comments:*), Bash(gh repo view:*), Bash(git branch --show-current), Read(*), Write(REVIEW_NOTES_*.md)
denied-tools: Bash(git push:*), Bash(git commit:*), Bash(git reset:*), Bash(git rebase:*), Edit(*)
description: Review and respond to PR comments
argument-hint: "[オプション: PR番号またはURL]"
model: sonnet
---

# Resolve Review

## コンテキスト

- 現在のブランチ: `!git branch --show-current`
- リポジトリ情報: `!gh repo view --json owner,name`

## タスク

PRに寄せられた**unresolved**なレビューコメントを取得し、各コメントに対する対応方針をユーザーに確認しながら、修正・返信を順番に実行していきます。

**注意:** このコマンドは`pr-review-handler`スキルと統合されています。詳細なワークフローとベストプラクティスについては、スキルのドキュメントを参照してください。

### 引数

- `$ARGUMENTS`: PR番号、URL、またはブランチ名
  - 指定がない場合: 現在のブランチのPRを使用
  - 例: `/resolve-review 123` または `/resolve-review feature/my-branch`

### 1. **PR番号の特定**

引数が指定されている場合:
  - PR番号、URL、ブランチ名のいずれかを解析
  - `gh pr view [引数] --json number,url,title` でPR情報を取得

引数がない場合:
  - 現在のブランチに対応するPRを取得
  - `gh pr view --json number,url,title`

PRが見つからない場合:
  - エラーメッセージを表示して終了

### 2. **Unresolved レビューコメントの取得**

GitHub GraphQL APIを使用してunresolvedなreviewThreadsを取得:

```bash
gh api graphql -f owner="$OWNER" -f repo="$REPO" -F pr="$PR_NUMBER" -f query='
  query FetchUnresolvedReviewThreads($owner: String!, $repo: String!, $pr: Int!) {
    repository(owner: $owner, repo: $repo) {
      pullRequest(number: $pr) {
        reviewThreads(first: 100) {
          nodes {
            isResolved
            id
            comments(first: 100) {
              nodes {
                id
                path
                body
                author {
                  login
                }
                createdAt
                position
                line
                diffHunk
              }
            }
          }
        }
      }
    }
  }
'
```

- `isResolved: false`のスレッドのみを抽出
- 各スレッドの最初のコメント(元のレビューコメント)を取得

Unresolvedコメントが0件の場合:
  - 「おめでとうございます!対応すべきレビューコメントはありません。」と表示して終了

### 3. **各コメントへの対応**

取得したunresolvedコメントを順番に処理:

#### a. コメント情報の表示

各コメントについて以下を表示:
- コメント番号: `[1/5]`
- ファイルパス: `src/utils/helper.ts:42`
- レビュアー: `@reviewer_name`
- コメント内容(マークダウン形式)
- 関連コード(diffHunkから表示)

#### b. 関連コードの表示

- `path`と`line`を使って該当ファイルの該当行周辺(前後5行程度)を`Read`ツールで取得して表示
- ファイルが見つからない場合はdiffHunkのみ表示

#### c. ユーザーに対応方針を確認

`AskUserQuestion`を使用して以下の選択肢を提示:

1. **コードを修正する提案を見る**
   - AIが修正案を生成して提示
   - ユーザーが承認したらAIが説明し、ユーザーが自分で修正する
   - (denied-toolsにEdit(*)があるため、AIは直接編集しない)

2. **コメントで返信する**
   - AIが返信文を生成(質問への回答、説明、議論など)
   - ユーザーが確認・編集後、`gh api`で返信を投稿

3. **スキップ(後で対応)**
   - 次のコメントへ進む
   - スキップしたコメントはREVIEW_NOTES_{PRNO}.mdに記録

#### d. 選択された対応を実行

**「コードを修正する」が選択された場合:**
1. レビュー指摘内容とコードを分析
2. 修正案を生成して詳しく説明
3. 修正すべきファイルパスと変更内容を明示
4. ユーザーに「自分で修正してください」と案内
5. 修正内容をREVIEW_NOTES_{PRNO}.mdに記録

**「返信する」が選択された場合:**
1. 状況に応じた返信文を生成
2. ユーザーに返信文を提示
3. ユーザーが承認したら`gh api`で投稿:
   ```bash
   gh api \
     repos/{owner}/{repo}/pulls/{pr_number}/comments/{comment_id}/replies \
     -f body="返信文"
   ```
4. 投稿結果をREVIEW_NOTES_{PRNO}.mdに記録

**「スキップ」が選択された場合:**
1. REVIEW_NOTES_{PRNO}.mdに「TODO」として記録
2. 次のコメントへ進む

### 4. **対応履歴の記録**

各コメントへの対応内容を`REVIEW_NOTES_{PRNO}.md`に記録:

```markdown
# PR #{PR_NUMBER} レビュー対応履歴

生成日時: 2025-11-25 18:34

## 対応サマリー

- 総コメント数: 5
- 修正提案: 2
- 返信: 2
- スキップ: 1

---

## [1/5] src/utils/helper.ts:42

**レビュアー:** @reviewer_name
**対応:** 修正提案を生成

**指摘内容:**
> この関数はエラーハンドリングが不足しています。

**修正内容:**
nullチェックを追加し、エラーケースを処理する...

---

## [2/5] ...
```

### 5. **完了サマリーの表示**

全てのコメント処理後、以下を表示:

```
✅ レビューコメント対応が完了しました!

📊 対応サマリー:
- 総コメント数: 5
- 修正提案: 2件
- 返信投稿: 2件
- スキップ: 1件

📝 詳細はREVIEW_NOTES_{PRNO}.mdを確認してください。

💡 次のステップ:
1. 提案された修正を実装
2. 変更をコミット: /commit
3. PRを更新: git push
```

## 重要な注意事項

- **安全性優先**: 各アクション前にAskUserQuestionで必ず確認
- **履歴管理**: 全ての対応内容をREVIEW_NOTES_{PRNO}.mdに記録
- **GraphQL制限**: 最大100件のreviewThreadsを取得。それ以上ある場合はページネーション実装を検討

## GraphQL API エラーハンドリング

- API呼び出しが失敗した場合、エラーメッセージを表示
- 認証エラーの場合、`gh auth status`を実行してログイン状態を確認するよう案内
- レート制限エラーの場合、待機時間を表示

## ユーザー追加指示

$ARGUMENTS
