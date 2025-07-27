#!/usr/bin/env zsh

autoload -Uz add-zsh-hook

function _update_tab_title_precmd() {
    local title
    if [[ "$PWD" == "$HOME" ]]; then
        title="~"
    elif [[ "${PWD:h}" == "/" ]]; then
        title="${PWD:t}"
    else
        title="${PWD:h:t}/${PWD:t}"
    fi
    
    case "$TERM_PROGRAM" in
        vscode)
            print -Pn "\e]0;${title}\a"
            ;;
        *)
            print -Pn "\e]2;${title}\a"
            ;;
    esac
}

function _update_tab_title_preexec() {
    local title
    if [[ "$PWD" == "$HOME" ]]; then
        title="~"
    elif [[ "${PWD:h}" == "/" ]]; then
        title="${PWD:t}"
    else
        title="${PWD:h:t}/${PWD:t}"
    fi
    
    local words=(${(z)1})
    local cmd="${words[1]} ${words[2]:-}"
    
    case "$TERM_PROGRAM" in
        vscode)
            print -Pn "\e]0;${title} - ${cmd}\a"
            ;;
        *)
            print -Pn "\e]2;${title} - ${cmd}\a"
            ;;
    esac
}

add-zsh-hook precmd _update_tab_title_precmd
add-zsh-hook preexec _update_tab_title_preexec