---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git diff:*), Bash(git log:*), Bash(git branch --show-current), Bash(git push:*), Read(*), Write(PR.md), Edit(PR.md), Bash(gh pr list:*), Bash(gh pr view:*), Bash(gh repo view:*), Bash(gh pr create:*), Bash(test -f PR.md)
denied-tools: Bash(git commit -n:*), Bash(git commit --no-verify:*), Bash(git reset --hard:*), Bash(git rebase:*), Bash(git push --force:*), mcp__github__merge_pull_request
description: コミット作成からPR作成まで一気通貫で実行
argument-hint: "[オプション: PRの背景や追加コンテキスト]"
---

# Commit, Push & Create PR

コミット作成 → PR説明生成 → プッシュ → PR作成を一気通貫で実行するコマンド

## コンテキスト

- 現在のブランチ: `!git branch --show-current`
- Gitステータス: `!git status`
- 最近のコミット: `!git log --oneline -10`
- `!gh repo view --json owner,name,defaultBranchRef`

## フロー概要

```
[変更確認] → [コミット作成] → [PR.md生成] → [Push] → [PR作成]
```

## タスク

### Phase 1: 事前確認

1. **ブランチ確認**
   - 現在のブランチがmain/master/developでないことを確認
   - メインブランチにいる場合は警告して終了

2. **既存PRの確認**
   ```bash
   gh pr list --head $(git branch --show-current)
   ```
   - PRが既に存在する場合は通知して終了

### Phase 2: コミット作成（未コミット変更がある場合）

1. **変更の確認**
   - `git status`で未コミット変更を確認
   - 変更がない場合はPhase 3へスキップ

2. **変更がある場合**
   - `git diff HEAD`で変更内容を確認
   - AskUserQuestionで確認:
     1. コミットする（コミットメッセージ候補を提示）
     2. 一部のファイルのみコミットする
     3. コミットせずにPRのみ作成する
     4. 中止する

3. **コミット実行**
   - 選択的にファイルをステージング（`git add .`は使わない）
   - コミットメッセージ候補を複数提示し、ユーザーに選択させる
   - コミット実行

4. **pre-commitフック失敗時**
   - AskUserQuestionで対応を確認:
     1. AIに修正を依頼する
     2. コミットを再試行する
     3. ユーザー自身が修正する
     4. 中止する

### Phase 3: PR説明の生成

1. **ユーザーのPRスタイル分析**
   ```bash
   gh pr list --author @me --state merged --limit 5
   ```
   - 過去のPRがあれば2-3件の詳細を取得してスタイルを分析

2. **PRテンプレート確認**
   - `.github/pull_request_template.md`または類似ファイルを確認

3. **コミット情報の収集**
   ```bash
   git log <ベースブランチ>..HEAD --pretty=format:"%s"
   git diff <ベースブランチ>..HEAD --stat
   ```

4. **PR.md生成**
   - PRテンプレートがあれば従う
   - なければ標準フォーマットで生成
   - **記載すべき内容**:
     - 背景・目的（なぜこの変更が必要か）
     - レビュー観点（特に見てほしいポイントがあれば）
   - **記載不要な内容**（レビュワーの負担軽減）:
     - テスト項目（CIで確認可能）
     - 変更ファイル一覧（Files changedで確認可能）
     - コードの詳細説明（diffで確認可能）
   - 背景が不明な場合はAskUserQuestionで確認
   - 簡潔に書く。レビュワーの時間を尊重する

5. **ユーザー確認**
   - 生成したPR.mdを表示
   - AskUserQuestionで確認:
     1. このまま続行する
     2. PR.mdを修正する（入力欄）
     3. 中止する

### Phase 4: Push & PR作成

1. **ブランチをプッシュ**
   ```bash
   git push -u origin $(git branch --show-current)
   ```

2. **PR作成**
   ```bash
   gh pr create --base <ベースブランチ> --title "$(head -n1 PR.md)" --body "$(tail -n+2 PR.md)" --draft
   ```

3. **完了通知**
   - PR URLを表示
   - ドラフトとして作成したことを通知
   - GitHub上で確認・公開を促す

## 重要な注意事項

- **選択的なステージング**: `git add .`は使用しない。関連ファイルのみステージング
- **コミットメッセージ**: リポジトリの既存コミットと同じ言語・スタイルを使用
- **ユーザーコミュニケーション**: 日本語で応答
- **ドラフトPR**: 安全のためドラフトとして作成
- **--no-verify禁止**: pre-commitフックをスキップしない

## ユーザー追加指示

$ARGUMENTS
