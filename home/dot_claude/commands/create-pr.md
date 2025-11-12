---
allowed-tools: Bash(git push:*), Bash(git log:*), Bash(git branch --show-current), Bash(git status:*), Read(PR.md), Bash(gh pr list:*), Bash(gh repo view:*)
denied-tools: Bash(git commit:*), Bash(git reset:*), Bash(git rebase:*), Edit(*), Write(*), mcp__github__create_pull_request, mcp__github__merge_pull_request
description: Push current branch and create a pull request using PR.md
argument-hint: "[オプション: PR作成時の追加指示]"
---

# Create PR

## コンテキスト

- 現在のブランチ: `!git branch --show-current`
- リモート追跡状態: `!git status -sb`
- 最近のコミット: `!git log --oneline -5`
- `!gh repo view --json owner,name`

## タスク

`PR.md` ファイルを使用して、現在のブランチをpushし、PRを作成します。

### 1. **ブランチとコミットの確認**

- 現在のブランチがmain/master/developでないことを確認
- pushすべきコミットがあることを確認
- コミットがない、またはmainブランチにいる場合は、ユーザーに通知して終了

### 2. **PR.mdの確認**

- リポジトリルートに`PR.md`が存在するか確認
- **PR.mdが存在する場合**:
  - ファイルを読み込み、内容を確認
  - 1行目: PRタイトル
  - 2行目以降: PR本文
- **PR.mdが存在しない場合**:
  - エラーメッセージを表示: "PR.mdが見つかりません。先に `/draft-pr` コマンドを実行してPR.mdを作成してください。"
  - 処理を終了

### 3. **既存PRの確認**

- 現在のブランチのPRが既に存在するか確認:

  ```bash
  gh pr list --head $(git branch --show-current)
  ```

- PRが既に存在する場合:
  - ユーザーに通知: "このブランチのPRは既に存在します: [PR URL]"
  - 処理を終了（更新機能は提供しない）

### 4. **ブランチのpush**

- originにupstream trackingでpush:

  ```bash
  git push -u origin $(git branch --show-current)
  ```

- push成功を確認

### 5. **PR作成の確認**

- PR.mdの内容をユーザーに表示
- 確認メッセージ: "以下の内容でPRを作成します。よろしいですか？"
- ユーザーの明示的な承認を待つ

### 6. **PR作成**（承認後）

- ベースブランチをもとにPRを作成:

  ```bash
  gh pr create --base "$(head -n1 PR.md)" --body "$(tail -n+2 PR.md)" < ベースブランチ > --title
  ```

- PR URLを表示
- 成功メッセージを表示

## 重要事項

- **ユーザー承認必須**: ユーザーの明示的な承認なしにPRを作成しない
- **PR.md必須**: PR.mdが存在しない場合は、`/draft-pr`を実行するよう案内
- **PR更新機能なし**: 既存PRの更新は行わない（新規作成のみ）
- **ユーザーコミュニケーション**: 日本語で応答

## `/draft-pr`との連携

このコマンドは2ステップワークフローの2番目です:

1. `/draft-pr` を実行 → PR.mdを生成
2. PR.mdを確認・編集
3. `/create-pr` を実行 → ブランチをpushしてPR作成

## ユーザー追加指示

$ARGUMENTS
