---
allowed-tools: Bash(git diff:*), Bash(git log:*), Bash(git branch --show-current), Bash(git status:*), mcp__github__list_pull_requests, mcp__github__get_pull_request, mcp__github__search_issues, Read(*), Write(PR.md), Edit(PR.md), Bash(gh pr list:*), Bash(gh pr view:*), Bash(gh repo view:*), Bash(git log develop..HEAD --pretty=format:"%s")
denied-tools: Bash(git push:*), Bash(git commit:*), Bash(git reset:*), Bash(git rebase:*), Bash(gh pr create:*), mcp__github__create_pull_request, mcp__github__merge_pull_request
description: 現在の変更に基づいてPR説明ファイル（PR.md）を生成
argument-hint: "[オプション: PR作成時の追加コンテキストや指示]"
model: haiku
---

# Draft PR

## コンテキスト

- 現在のブランチ: `!git branch --show-current`
- Gitステータス: `!git status --short`
- 最近のコミット: `!git log --oneline -10`
- `!gh repo view --json owner,name`
- think

## タスク

現在のブランチの変更に基づいてPR説明ファイル（`PR.md`）を生成してください。このファイルは`/create-pr`コマンドで実際のプルリクエストを作成する際に使用されます。

### 1. **ブランチの確認**

現在のブランチがmain/developでないことを確認
PRに含めるコミットがあるか確認

- コミットがないか、mainブランチにいる場合はユーザーに通知して終了

### 2. **既存のPR.mdの確認**

`PR.md`が既に存在する場合:
その内容を読み取る
ユーザーに上書きするか編集するか尋ねる（AskUserQuestionを使用）
既存のものを保持したい場合は終了

- `PR.md`が存在しない場合:
  - 生成を進める

### 3. **ユーザーのPRスタイルの分析**

- ユーザーの過去のPRを検索: `gh pr list --author @me --state merged --limit 10`
- ユーザーに過去のPRがある場合:
  最近の2-3件のPRの詳細を取得

- 分析: タイトル形式、説明構造、使用言語
- PR説明の書き方のパターンを記録

### 4. **PRコンテキストの収集**

PRテンプレートを確認: `.github/pull_request_template.md`または類似ファイル
メモリやドキュメントに`/beauty-pr`スタイルのテンプレートが存在するか確認
現在のブランチからコミットメッセージを取得:

- `git log <ベースブランチ>..HEAD --pretty=format:"%s"`
- ファイル変更を取得:

`git diff <ベースブランチ>..HEAD --stat`

- `git diff <ベースブランチ>..HEAD`（詳細な変更用）

### 5. **PR.mdの生成**

.github/PULL_REQUEST_TEMPLATE.mdの内容に従い、PR.mdを生成する

PRには背景情報を含めるように意識する。
例: 「この変更は〇〇のパフォーマンス改善のため」「△△との互換性を保つため」「XXにより不要になったため」
背景情報が汲み取れない場合は、AskUserQuestionを使用してユーザーに尋ねる。

1. **ユーザーへの提示**

- 生成された`PR.md`の内容を表示
- ユーザーに通知、AskUserQuestionを使用してPR.mdの内容についての確認を求める

1. 問題ない、/create-prを実行する
2. 問題がある、PR.mdを手動で編集する
3. AIに変更を依頼する（入力欄）

## 重要な注意事項

- PR.mdのみを生成し、実際のPRは作成しない

## /create-prとの統合

このコマンドは最初のステップです:

1. `/draft-pr`を実行してPR.mdを生成
2. 必要に応じてPR.mdをレビューおよび編集
3. `/create-pr`を実行してブランチをプッシュし、PR.mdを使用してPRを作成

## ユーザー追加指示

$ARGUMENTS
