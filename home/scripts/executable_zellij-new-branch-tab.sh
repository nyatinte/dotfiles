#!/bin/bash

# 現在のブランチ名を取得
branch_name=$(git branch --show-current)

# ブランチ名が取得できない場合のフォールバック
if [ -z "$branch_name" ]; then
    branch_name="no-branch"
fi

# 新しいタブを作成
zellij action new-tab --name "$branch_name"

# 左ペインでclaude codeを起動
zellij action write-chars "claude code"
zellij action write 10  # Enter key

# 右にペインを分割
zellij action new-pane --direction right

# 左ペインに名前をつける
zellij action focus-previous-pane
zellij action rename-pane "claude"

# 右ペインに名前をつける
zellij action focus-next-pane
zellij action rename-pane "free"
