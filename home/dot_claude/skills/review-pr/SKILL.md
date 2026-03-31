---
allowed-tools: Read(*), Glob(*), Grep(*), Write(.claude/reviews/*), Bash(gh pr view *), Bash(gh pr diff *), Bash(gh issue view *), Bash(bash */.claude/skills/fix-review/scripts/get-review-threads.sh),Bash(mkdir */.claude/reviews/*)
denied-tools: Bash(git push *), Bash(git commit *), Bash(git checkout *), Bash(git reset *), Edit(*)
description: PRのコードレビューを実施するときに使用。PRの概要から既存レビューコメントの確認、変更コードの分析まで行い、ユーザーと共同しながらレビューコメントを生成する。
argument-hint: "[オプション: レビュー観点やフォーカスしたい領域]"
---

# review-pr Skill

> レビュー指摘への対応は `fix-review` skill を使用してください。

## 概要

現在のブランチのPRに対してコードレビューを実施し、レビューコメントを `.claude/reviews/{pr_number}/{index}.md` に出力する

## 手順

1. `gh pr view --json number,title,body,files` を実行して、PRの概要・変更ファイル一覧を把握する
   1. PR本文に記載されたissueやドキュメントのリンクがあれば `gh issue view` や `WebFetch` で内容を確認する
2. `.claude/skills/fix-review/scripts/get-review-threads.sh` を実行して、既存のレビューコメントを確認する
   1. 未解決のスレッドがあれば把握し、同じ論点の重複指摘を避ける
3. `gh pr diff` を実行して、変更内容のdiffを確認する
4. 変更があったファイルを `Read` で確認する（自動生成ファイルは基本スキップ）
   1. 必要に応じて `Glob` / `Grep` で関連コードや使用箇所を調査する
5. 使用や実装方針など少しでも不明点があれば AskUserQuestion Tool でユーザーに確認する
6. `.claude/skills/review-pr/review-guidelines.md` の内容に従ってレビューコメントを作成する
7. `.claude/reviews/{pr_number}/{index}.md` にレビュー結果を書き出し、サマリーをユーザーに報告して終了する
