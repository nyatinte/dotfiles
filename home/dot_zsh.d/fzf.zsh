export FZF_DEFAULT_OPTS='
  --height 50%
  --layout=reverse
  --border
  --preview-window=right:60%:wrap
  --color=fg:#e5e9f0,bg:#2e3440,hl:#81a1c1
  --color=fg+:#d8dee9,bg+:#3b4252,hl+:#81a1c1
  --color=info:#eacb8a,prompt:#bf616a,pointer:#b48ead
  --color=marker:#a3be8c,spinner:#b48ead,header:#88c0d0'

# Ctrl+T - File Search
export FZF_CTRL_T_COMMAND="rg --files --hidden --follow --glob '!.git/*' --glob '!node_modules/*'"
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --style=numbers --line-range=:500 {}'
  --preview-window=right:60%:wrap"

# Alt+C - Directory Search
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git --exclude node_modules"
export FZF_ALT_C_OPTS="
  --preview 'ls -la --color=always {} | head -200'
  --preview-window=right:60%:wrap"

# Ctrl+R - History Search
function fzf-select-history() {
    BUFFER=$(history -n -r 1 | fzf --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N fzf-select-history
bindkey '^r' fzf-select-history

# Ctrl+G - Keyword Search (ripgrep + fzf)
function fzf-keyword-search() {
    local selected
    selected=$(
        rg --line-number --no-heading --color=always --smart-case '' 2>/dev/null |
        fzf --ansi \
            --delimiter ':' \
            --preview 'bat --color=always --style=numbers --highlight-line {2} {1}' \
            --preview-window 'right:60%:+{2}+3/3:wrap' \
            --bind 'enter:become(echo {1}:{2})'
    )

    if [[ -n "$selected" ]]; then
        local file="${selected%%:*}"
        local line="${selected#*:}"
        # エディタで開く（環境変数 EDITOR を使用、デフォルトは vim）
        ${EDITOR:-vim} "+${line}" "$file"
    fi
    zle reset-prompt
}
zle -N fzf-keyword-search
bindkey '^g' fzf-keyword-search
