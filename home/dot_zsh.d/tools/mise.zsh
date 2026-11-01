# Create _cmd symlinks for mise tool completions (must run before compinit).
# Only link when missing: relinking on every startup spawns ln and is slow.
() {
	local completions_dir="${HOME}/.zsh.d/completions"
	local _compl _dest
	for _compl in ~/.local/share/mise/installs/*/latest/*/autocomplete/*.zsh(N); do
		_dest="${completions_dir}/_${_compl:t:r}"
		[[ -e "$_dest" ]] && continue
		ln -sf "$_compl" "$_dest"
	done
}

eval "$(mise activate zsh)"
