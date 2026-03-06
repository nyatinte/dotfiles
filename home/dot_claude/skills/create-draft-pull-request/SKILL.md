---
allowed-tools: Read(*), Glob(*), Grep(*), Write(PR.md), Edit(PR.md), Bash(git branch *), Bash(git log *), Bash(git diff *), Bash(git fetch *), Bash(git rev-list *), Bash(git push -u *), Bash(gh repo view *), Bash(gh pr edit *), Bash(gh pr create *), Bash(gh pr view *), Bash(gh pr list *), Bash(gh pr diff *), Bash(*/.claude/skills/create-draft-pull-request/scripts/check-branch.sh), Bash(*/.claude/skills/create-draft-pull-request/scripts/summarize-pr-diff.sh), Edit(PR.md), Write(PR.md)
denied-tools: Bash(git push * -f *), Bash(git push * --force *)
description: 現在のブランチからPR説明文を生成し、承認後にGitHub PRを作成。ユーザーから PR 作成を依頼された場合や、実装作業完了時に PR 作成したほうが良いと思われる場合に使用。
argument-hint: "[オプション: PR作成時の追加コンテキストや指示]"
model: sonnet
---

# create-draft-pull-request Skill

## 概要

現在のブランチの変更からPR説明文（PR.md）を自動生成し、ユーザー確認後にGitHub PRを作成してください。
PRはユーザーの意図を明確に反映させるため、 AskUserQuestion を使ったユーザーへのヒアリングを意識してください。

## 手順

1. `Bash(.claude/skills/create-draft-pull-request/scripts/check-branch.sh)` を実行して、ブランチとコミット情報を取得
   1. 現在のブランチが develop/main/master でないか確認
   2. コミット数が0でないか確認
   3. 問題があればユーザーに通知して終了
2. `Bash(.claude/skills/create-draft-pull-request/scripts/summarize-pr-diff.sh)` を実行して、PR全体の変更規模を確認する
   - **閾値**: `changed_files >= 10` または `total_changed_lines >= 300` の場合、変更が大きいと判断する
   - 閾値を超えた場合、`/simplify https://zenn.dev/aki1990/articles/c95ca551a1f458` を実行してコードの簡潔化・品質改善を行う。simplify の完了後、改めてこの手順の最初から再実行する
3. 既存PRの確認: `gh pr list --head $(git branch --show-current) --json number,url`
   1. 既に存在する場合は AskUserQuestion Tool でユーザーに対応方針を選択してもらう
4. `.claude/skills/create-draft-pull-request/pull-request-message.md` の内容を必ず確認してから、PR の内容を Write or Edit Tool で PR.md に書き出す。意図を明確にするために AskUserQuestion によるヒアリングも必要に応じて行う
5. PR.md の内容を表示し、AskUserQuestion Tool でユーザーに確認
   1. 選択肢: 承認してPR作成 / AIに修正依頼 / 手動編集 / キャンセル
6. 承認された場合、ブランチをリモートに push: `git push -u origin $(git branch --show-current)`
7. PR作成: `gh pr create --base <base-branch> --title "$(head -n1 PR.md)" --body "$(tail -n+2 PR.md)" --draft`
8. PR作成後、確認: `gh pr view <PR番号> --json number,url,title,isDraft`

完了後、 ユーザーに PR の URL を通知して終了
