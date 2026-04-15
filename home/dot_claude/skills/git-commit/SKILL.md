---
allowed-tools: Read(*), Bash(git commit *), Bash(git log *), Bash(git diff *), Bash(git status *), Bash(git branch *), Bash(git add *), Bash(bash *.claude/skills/git-commit/scripts/analyze-git-diff.sh *), Bash(sh *.claude/skills/git-commit/scripts/analyze-git-diff.sh *)
denied-tools: Bash(git push *)
description: 現在の差分に基づいて git commit を作成する。 ユーザーから commit を依頼された場合や、タスク完了時に commit したほうが良い場合に使用。
argument-hint: "[Context: commit message に含めるべき Context, Auto: true にすると AskUserQuestion を一切使わず自動で commit する (default: false) ]"
model: haiku
---

# git-commit Skill

## 概要

現在の差分に基づいて git commit を作成する。

## 手順

1. `Bash(bash $CLAUDE_SKILL_DIR/scripts/analyze-git-diff.sh)` を実行（必要なら `--no-diff`）
2. (Auto が false の場合) commit の単位が複数ありそうな場合、AskUserQuestion で commit の単位を選択してもらう。Auto が true の場合はすべての変更を1つの commit にまとめる
3. git add でステージング
4. スクリプト出力と `commit-message.md` を参照し、commit message 候補を3つ作成
5. (Auto が false の場合) AskUserQuestion Tool でユーザーに候補を提示する。Auto が true の場合は候補の1番目を自動選択する
6. git commit を実行して、コミットを作成
   1. もし pre-commit フックが失敗した場合、 AskUserQuestion Tool で対応方針を選択してもらう（AIに修正を依頼する、コミットを再試行する、--no-verifyを使用してコミットを再試行する、ユーザー自身が修正する）
7. commit 成功後、 git log を実行して、コミットハッシュを取得、ユーザーに報告して終了

実装作業が完了しており、残りは PR 作成だと思われる場合、 Pull Request 作成の Skill を実行してください
