---
allowed-tools: Read(*), Edit(*), Bash(git status *), Bash(git diff *), Bash(git log *), Bash(git show *), Bash(git branch *), Bash(git ls-files -u *), Bash(git merge *), Bash(git rebase *), Bash(git add *), Bash(git checkout --ours *), Bash(git checkout --theirs *), Bash(git rebase --continue), Bash(git merge --continue), Bash(git rebase --abort), Bash(git merge --abort), Bash(gh pr list *), Bash(gh pr view *), Bash(*analyze-conflict.sh*)
denied-tools: Bash(git push *), Bash(git reset --hard *)
description: コンフリクトを解決するための支援コマンド
argument-hint: "[オプション: 解決の方針に関する追加コンテキスト]"
---

# resolve-conflict Skill

## 概要

Git merge/rebase で発生したコンフリクトを分析し、解決方針をユーザーに提案してから実際の解決作業を行う。

## 手順

1. `Bash(.claude/skills/resolve-conflict/scripts/analyze-conflict.sh)` を実行してコンフリクト状態を確認
   - コンフリクト状態でない場合、ユーザーに通知して終了
2. 各コンフリクトファイルの内容を `Read` で読み込み、コンフリクトマーカー(`<<<<<<<`, `=======`, `>>>>>>>`)の箇所を特定
3. 変更の背景を理解するため情報収集:
   - `git log -p --all -- <ファイル>` で変更履歴を確認
   - `gh pr list --head $(git branch --show-current)` で関連PRを確認
   - コンフリクト箇所の周辺コードから機能的な文脈を分析
4. `AskUserQuestion` で意味論的な解決方針を提案（1ファイルずつ段階的に解決）:
   - 単純に「OURS」「THEIRS」ではなく、変更の意図を明確に説明した選択肢を作成
   - 推奨される選択肢には理由を付ける
   - 選択肢例: ブランチAの機能を優先 / マージ元の実装を優先 / 両方を統合 / 手動で解決
5. ユーザー承認後、選択された方針で解決を実行:
   - OURS: `git checkout --ours <ファイル>` → `git add`
   - THEIRS: `git checkout --theirs <ファイル>` → `git add`
   - 統合: `Edit` でコンフリクトマーカーを削除し両方の変更を統合 → `git add`
   - 手動: ユーザーに案内して処理終了
6. 全コンフリクト解決後、`git status` で確認し `AskUserQuestion` で次のアクションを提案:
   - rebase中: `git rebase --continue`
   - merge中: `git merge --continue`
   - 中止: `git rebase --abort` / `git merge --abort`

## ユーザー追加指示

$ARGUMENTS
