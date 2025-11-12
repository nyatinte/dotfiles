---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git diff:*), Bash(git log:*), Bash(git branch --show-current), Read(*)
denied-tools: Bash(git push:*), Bash(git commit -n:*), Bash(git commit --no-verify), Bash(git reset:*), Bash(git rebase:*), Edit(*), Write(*)
description: gitコミットを作成
argument-hint: "[オプション: 特定のファイルまたはコミットメッセージのコンテキスト]"
model: haiku
---

# Commit

## コンテキスト

- 現在のgitステータス: `!git status`
- 現在のgit diff（ステージング済みおよび未ステージングの変更）: `!git diff HEAD`
- 現在のブランチ: `!git branch --show-current`
- 最近のコミット: `!git log --oneline -10`

## タスク

上記の変更に基づいて、単一のgitコミットを作成してください。
commitメッセージはいくつか草案を出し、AskUserQuestionを用いてユーザーに選択を求めること。

## 重要な注意事項

- **選択的なステージング**: タスクに直接関連するファイルのみをステージングしてください。一時的なメモや関連のない作業中のファイルが含まれる可能性があるため、`git add .`は使用しないでください
- **コミットメッセージ**: リポジトリの既存のコミットと同じ言語を使用（最近のコミット履歴を確認）
- **ユーザーとのコミュニケーション**: 日本語で返信してください（日本語で返信してください）
- **pre-commitフック**: pre-commitフックが失敗した場合:
  - AskUserQuestionを用いて、ユーザーに4択で確認を求める
  1. AIに修正を依頼する
  2. コミットを再試行する
  3. --no-verifyを使用してコミットを再試行する
  4. ユーザー自信が修正する

## コミットメッセージのガイドライン

- このプロジェクトのコミットメッセージ規約に従う
- コミットメッセージでは**Why**（なぜこの変更が必要か）に焦点を当てる
- 簡潔だが説明的にする
- コミットメッセージには日本語を使用（このリポジトリは日本語を使用）
