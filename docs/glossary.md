# 用語集

設計判断や ADR で使う Claude Code 権限まわりの用語をまとめる。

## 権限ルール

`Tool` または `Tool(specifier)` 形式で書く許可・確認・拒否のルール。`Tool` だけならそのツールの全使用に一致する。

## allow / ask / deny

ルールの 3 分類。評価順は deny、ask、allow で、最初に一致したものが採用される。allow は deny を打ち消せない。

## アンカー

パスパターンの起点。`//` はファイルシステムのルート、`~/` はホームディレクトリ、`/` は設定ファイルの場所、前置きなしと `./` はカレントディレクトリを基準にする。

## Read deny と Edit deny

`Read(path)` は読み取りを止める。同じパスの Edit と Write も塞ぐが NotebookEdit は対象外なので、変更も禁じたいパスには `Edit(path)` を別途書く。

## ミラー

`Read` の deny と同じパスを `Edit` でも列挙する運用。NotebookEdit の穴を塞ぐために使う。

## すり抜け経路

deny ルールが効かない読み書き。パスを名指ししない `grep -r` や、スクリプトからの直接 open など。OS レベルで塞ぐには sandbox を使う。

## chezmoi ソースと実ファイル

`home/` 配下のソースファイルと、`$HOME` に展開された実ファイル。編集は常にソースに対して行い、`chezmoi apply` で反映する。
