# fzf 拡張設定 - 既存ツール（bat、eza、rg）との連携

# 基本設定
export FZF_DEFAULT_OPTS='
  --height 40% 
  --layout=reverse 
  --border 
  --preview-window=right:60%:wrap
  --bind ctrl-u:preview-up,ctrl-d:preview-down
  --bind ctrl-f:preview-page-down,ctrl-b:preview-page-up
  --color=fg:#e5e9f0,bg:#2e3440,hl:#81a1c1
  --color=fg+:#d8dee9,bg+:#3b4252,hl+:#81a1c1
  --color=info:#eacb8a,prompt:#bf616a,pointer:#b48ead
  --color=marker:#a3be8c,spinner:#b48ead,header:#88c0d0'

# プロジェクトルートから検索（Gitリポジトリ内ならプロジェクトルート、そうでなければカレントディレクトリ）
get_project_root() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git rev-parse --show-toplevel
  else
    pwd
  fi
}

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!node_modules/*" "$(get_project_root)"'

# Ctrl+T - ファイル検索（batでプレビュー）
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS='
  --preview "bat --color=always --style=numbers --line-range=:500 {}" 
  --preview-window=right:60%:wrap'

# Alt+C - ディレクトリ検索（ezaでプレビュー）
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules "$(get_project_root)"'
export FZF_ALT_C_OPTS='
  --preview "eza --tree --level=2 --icons --git --color=always {}" 
  --preview-window=right:60%:wrap'

# Ctrl+R - コマンド履歴検索（拡張プレビュー）
export FZF_CTRL_R_OPTS='
  --preview "echo {}" 
  --preview-window down:3:hidden:wrap 
  --bind "?:toggle-preview"'

# カスタム関数定義

# ff - ファイル検索してエディターで開く
# 使用法: ff [検索開始ディレクトリ] (デフォルト: $HOME)
ff() {
  local search_dir="${1:-$HOME}"
  local files
  files=$(rg --files --hidden --follow --glob "!.git/*" --glob "!node_modules/*" "$search_dir" | 
    fzf --multi --preview 'bat --color=always --style=numbers --line-range=:500 {}')
  [[ -n "$files" ]] && code $files
}

# fcd - ディレクトリ検索して移動
# 使用法: fcd [検索開始ディレクトリ] (デフォルト: $HOME)
fcd() {
  local search_dir="${1:-$HOME}"
  local dir
  dir=$(fd --type d --hidden --follow --exclude .git --exclude node_modules . "$search_dir" | 
    fzf --preview 'eza --tree --level=2 --icons --git --color=always {}')
  [[ -n "$dir" ]] && cd "$dir"
}

# frg - ripgrepの結果をfzfで絞り込み
# 使用法: frg <検索パターン> [検索開始ディレクトリ] (デフォルト: $HOME)
frg() {
  local pattern="$1"
  local search_dir="${2:-$HOME}"
  
  if [[ -z "$pattern" ]]; then
    echo "使用法: frg <検索パターン> [検索開始ディレクトリ]"
    return 1
  fi
  
  local result
  result=$(rg --color=always --line-number --no-heading --smart-case "$pattern" "$search_dir" |
    fzf --ansi \
        --delimiter : \
        --preview 'bat --color=always --highlight-line {2} {1}' \
        --preview-window 'right:60%:+{2}-5')
  
  if [[ -n "$result" ]]; then
    local file=$(echo "$result" | cut -d: -f1)
    local line=$(echo "$result" | cut -d: -f2)
    code "$file:$line"
  fi
}

# fkill - プロセス検索して kill
fkill() {
  local pids
  pids=$(ps -f -u $USER | sed 1d | fzf --multi | awk '{print $2}')
  [[ -n "$pids" ]] && echo "$pids" | xargs kill -${1:-9}
}

# fbr - Gitブランチ検索して切り替え
fbr() {
  local branches branch
  branches=$(git branch -a | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d 15 +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# flog - Gitログ検索
flog() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# fstash - Git stash検索
fstash() {
  local out q k sha
  while out=$(
    git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
    fzf --ansi --no-sort --query="$q" --print-query \
        --expect=ctrl-d,ctrl-b);
  do
    mapfile -t out <<< "$out"
    q="${out[0]}"
    k="${out[1]}"
    sha="${out[-1]}"
    sha="${sha%% *}"
    [[ -z "$sha" ]] && continue
    if [[ "$k" == 'ctrl-d' ]]; then
      git diff $sha
    elif [[ "$k" == 'ctrl-b' ]]; then
      git stash branch "stash-$sha" $sha
      break;
    else
      git stash show -p $sha
    fi
  done
}

# fenv - 環境変数検索
fenv() {
  env | fzf --preview 'echo {}' --height 50%
}

# fpath - PATH検索
fpath() {
  echo $PATH | tr ':' '\n' | fzf --preview 'ls -la {}'
}