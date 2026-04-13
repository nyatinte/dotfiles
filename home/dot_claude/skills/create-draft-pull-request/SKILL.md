---
allowed-tools: Read(*), Glob(*), Grep(*), Write(PR.md), Edit(PR.md), Bash(git log * -n *), Bash(git diff *), Bash(gh pr edit *), Bash(bash */.claude/skills/create-draft-pull-request/scripts/check-branch.sh), Bash(bash */.claude/skills/create-draft-pull-request/scripts/get-pr-style.sh), Bash(bash */.claude/skills/create-draft-pull-request/scripts/push-and-create-pr.sh *)
denied-tools: Bash(git push * -f *), Bash(git push * --force *)
description: 現在のブランチからPR説明文を生成し、承認後にGitHub PRを作成。ユーザーから PR 作成を依頼された場合や、実装作業完了時に PR 作成したほうが良いと思われる場合に使用。
argument-hint: "[オプション: PR作成時の追加コンテキストや指示 / Auto: true にすると AskUserQuestion を使わず自動でPRを作成する (default: false)]"
---

# create-draft-pull-request Skill

## 概要

現在のブランチの変更からPR説明文（PR.md）を自動生成し、GitHub PRを作成する。

## 手順

1. `Bash(.claude/skills/create-draft-pull-request/scripts/check-branch.sh)` を実行してブランチ・コミット・既存PR情報を取得
   1. 現在のブランチが develop/main/master でないか確認
   2. コミット数が0でないか確認
   3. 既存PRが存在する場合、Auto が false のときのみ AskUserQuestion でユーザーに対応方針を選択してもらう
   4. 問題があればユーザーに通知して終了
2. `Bash(.claude/skills/create-draft-pull-request/scripts/get-pr-style.sh)` を実行して過去PRのスタイルを取得する
3. `.claude/skills/create-draft-pull-request/pull-request-message.md` を参照し、**PR.md** を Write または Edit で書き出す
   - `PR.md` の先頭がタイトルになるため、要注意！
   - Auto が false の場合、意図を明確にするために AskUserQuestion によるヒアリングも必要に応じて行う
4. Auto が false の場合、PR.md の内容を表示し AskUserQuestion でユーザーに確認する
   - 選択肢: 承認してPR作成 / AIに修正依頼 / 手動編集 / キャンセル
5. `Bash(.claude/skills/create-draft-pull-request/scripts/push-and-create-pr.sh <base-branch>)` を実行して push と PR 作成を行う
   - スクリプトは `PR.md` をデフォルトで読む（パスは引数で上書き可）
   - スクリプトが出力する PR URL をユーザーに通知して終了
