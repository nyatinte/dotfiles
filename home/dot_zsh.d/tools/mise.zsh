# Create _cmd symlinks for mise tool completions (must run before compinit)
() {
  local completions_dir="${HOME}/.zsh.d/completions"
  for _compl in ~/.local/share/mise/installs/*/latest/*/autocomplete/*.zsh(N); do
    ln -sf "$_compl" "${completions_dir}/_${_compl:t:r}"
  done
}

eval "$(mise activate zsh)"
