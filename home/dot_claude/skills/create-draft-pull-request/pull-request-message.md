# PR作成ガイド

このドキュメントは、PR本文作成時のガイドラインと分析手順を記載します。

## 基本原則

### Whyを重視

PR本文では**Why**（なぜこの変更が必要か）に焦点を当てる。
どんな変更をしたかは diff でわかるので、詳細に書く必要はない。最低限の変更内容を書けば良い。

WHY が不明瞭な場合は、いくつか推測し、AskUserQuestion Tool でユーザーに選択してもらう

## PR作成の手順

### 1. ユーザーのPRスタイル分析

過去のPRを分析して、プロジェクトのスタイルに合わせる:

```sh
# 過去のPRを取得
gh pr list --author @me --state merged --limit 10 --json number,title,url

# 最近の2-3件のPRを詳細取得
gh pr view <PR番号> --json title,body
```

### 2. PRテンプレートの確認

.github/PULL_REQUEST_TEMPLATE.md に従う。

### 3. コミット情報の収集

```sh
# コミットメッセージを取得
git log <base-branch>..HEAD --pretty=format:"%s" --reverse

# 変更統計
git diff <base-branch>..HEAD --stat

# 変更ファイル一覧
git diff <base-branch>..HEAD --name-only
```

### 4. 背景情報の推測

PR の差分や、これまでの会話内容から背景を推測する。
不明な場合は AskUserQuestion Tool で確認し、推測した内容を選択肢として提示

## PR本文フォーマット

### タイトル

一般的なConventional Commits形式を使用

## ベストプラクティス

### Good

- Whyを明確にする
- 簡潔に書く（タイトルは70文字以内）
- AI Slop が排除されており、ユーザーが確認しやすい
- 曖昧なことは書かない（書くべきだと判断した場合、AskUserQuestion Tool でユーザーに詳細を確認する）
- Referenceとして参考リンクやドキュメントが記載されている

### Bad

- Whatだけを書く（「ファイルを変更」）
- 曖昧な表現（「いろいろ修正」）
- 不必要に長い説明
- 箇条書き、太字、絵文字などが過度に使用されたいかにも AI な PR 本文
