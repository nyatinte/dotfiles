#!/bin/bash

branch_name=$(git branch --show-current 2>/dev/null || echo "worktree")
current_dir=$(pwd)

zellij action new-tab --name "$branch_name"
zellij action write-chars "claude code"
zellij action write 10
zellij action new-pane --direction right --cwd "$current_dir"
zellij action write-chars "cd \"$current_dir\""
zellij action write 10
zellij action focus-previous-pane
zellij action rename-pane "claude"
zellij action focus-next-pane
zellij action rename-pane "claude"
