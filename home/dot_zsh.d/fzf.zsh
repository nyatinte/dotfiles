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

function fzf-file-widget() {
    local selected
    selected=$(
        eval "$FZF_CTRL_T_COMMAND" |
        fzf --ansi \
            --select-1 --exit-0 \
            --bind ">:reload(rg --files --hidden --follow --glob '!.git/*' --glob '!node_modules/*')" \
            --bind "<:reload($FZF_CTRL_T_COMMAND)" \
            --preview 'bat --color=always --style=numbers --line-range=:500 {}' \
            --preview-window=right:60%:wrap
    )

    if [[ -n "$selected" ]]; then
        LBUFFER="${LBUFFER}${selected}"
    fi
    zle reset-prompt
}
zle -N fzf-file-widget
bindkey '^T' fzf-file-widget

# Alt+C - Directory Search
export FZF_ALT_C_COMMAND="fd --type d --exclude .git --exclude node_modules"

function fzf-cd-widget() {
    local selected
    selected=$(
        eval "$FZF_ALT_C_COMMAND" |
        fzf --ansi \
            --select-1 --exit-0 \
            --bind '>:reload(fd --type d --hidden --exclude .git --exclude node_modules)' \
            --bind "<:reload($FZF_ALT_C_COMMAND)" \
            --preview 'eza --tree --level=3 --color=always {} | head -200' \
            --preview-window=right:60%:wrap
    )

    if [[ -n "$selected" ]]; then
        cd "$selected"
    fi
    zle reset-prompt
}
zle -N fzf-cd-widget
bindkey '\ec' fzf-cd-widget  # Alt+C

# Ctrl+R - History Search
function fzf-select-history() {
    BUFFER=$(history -n -r 1 | fzf --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N fzf-select-history
bindkey '^r' fzf-select-history

# Ctrl+G - Keyword Search (ripgrep + fzf with dynamic reload)
function fzf-keyword-search() {
    local rg_cmd="rg --smart-case --line-number --no-heading --color=always --trim"
    local selected

    selected=$(
        FZF_DEFAULT_COMMAND=":" \
        fzf --ansi --phony \
            --delimiter ':' \
            --bind "change:reload:$rg_cmd {q} || true" \
            --preview 'bat --color=always --style=numbers --highlight-line {2} {1}' \
            --preview-window 'right:60%:+{2}+3/3:wrap' \
            --bind 'enter:become(echo {1}:{2})'
    )

    if [[ -n "$selected" ]]; then
        local file="${selected%%:*}"
        local line="${selected#*:}"
        line="${line%%:*}"  # Remove any trailing content after line number
        ${EDITOR:-vim} "+${line}" "$file"
    fi
    zle reset-prompt
}
zle -N fzf-keyword-search
bindkey '^g' fzf-keyword-search
