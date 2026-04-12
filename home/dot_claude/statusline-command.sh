#!/usr/bin/env sh
input=$(cat)

# --- Parse JSON ---
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(printf '%s' "$input" | jq -r '.model.display_name // ""')
git_worktree=$(printf '%s' "$input" | jq -r '.workspace.git_worktree // ""')
used=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')
total_in=$(printf '%s' "$input" | jq -r '.context_window.total_input_tokens // 0')
total_out=$(printf '%s' "$input" | jq -r '.context_window.total_output_tokens // 0')

# --- cwd: fish-style shorten (~/a/b/long-dir -> ~/a/b/long-dir) ---
home="$HOME"
cwd_short="${cwd#"$home"}"
[ "$cwd_short" != "$cwd" ] && cwd_short="~$cwd_short"
# Shorten each parent segment to first character: ~/a/b/project -> ~/a/b/project
cwd_display=$(printf '%s' "$cwd_short" | awk -F'/' '{
  for (i = 1; i <= NF; i++) {
    if (i == NF) printf "%s", $i
    else if ($i == "" || $i == "~") printf "%s/", $i
    else if (substr($i, 1, 1) == ".") printf "%.2s/", $i
    else printf "%c/", substr($i, 1, 1)
  }
}')

# --- git branch (fast local command) ---
git_branch=""
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git_branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
fi

# --- model: shorten display name ---
# "Claude Sonnet 4.6" -> "sonnet-4.6"
model_short=$(printf '%s' "$model" | sed 's/Claude //;s/ /-/g' | tr '[:upper:]' '[:lower:]')

# --- context window usage ---
ctx_str=""
if [ -n "$used" ]; then
  used_int=$(printf "%.0f" "$used")
  ctx_str="ctx:${used_int}%"
fi

# --- session cost estimate (Sonnet 4.6: $3/M input, $15/M output) ---
cost_str=""
if [ "$total_in" -gt 0 ] || [ "$total_out" -gt 0 ]; then
  cost=$(awk "BEGIN { c = ($total_in * 3 + $total_out * 15) / 1000000; printf (c < 0.01 ? \"<\$0.01\" : \"\$%.2f\"), c }")
  cost_str="$cost"
fi

# --- build status line ---
out="$cwd_display"
[ -n "$git_branch" ] && out="$out  $git_branch"
[ -n "$git_worktree" ] && out="$out [$git_worktree]"
[ -n "$model_short" ] && out="$out | $model_short"
[ -n "$ctx_str" ] && out="$out | $ctx_str"
[ -n "$cost_str" ] && out="$out | $cost_str"

printf "%s" "$out"
