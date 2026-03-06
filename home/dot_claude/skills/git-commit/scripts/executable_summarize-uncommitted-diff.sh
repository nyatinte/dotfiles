#!/bin/sh

# Summarize uncommitted diff lines.
# Generated files are ignored.

changed_files=0
total_changed_lines=0

is_generated() {
  path="$1"

  attrs="$(git check-attr linguist-generated -- "$path")"

  case "$attrs" in
    *"linguist-generated: set"*|*"linguist-generated: true"*)
      return 0
      ;;
  esac

  case "$path" in
    *.min.js|*.min.css|*.map|\
    package-lock.json|yarn.lock|pnpm-lock.yaml|Cargo.lock|\
    dist/*|*/dist/*|build/*|*/build/*|\
    generated/*|*/generated/*|\
    *.generated.*|*_generated.*)
      return 0
      ;;
  esac

  return 1
}

tmp_file="/tmp/git_diff_summary.$$"

git diff HEAD --numstat --find-renames > "$tmp_file"

while IFS='	' read -r added deleted path
do
  [ -z "$path" ] && continue

  target_path="$path"
  case "$path" in
    *" => "*)
      target_path="${path##* => }"
      target_path="${target_path#\{}"
      target_path="${target_path%\}}"
      ;;
  esac

  if is_generated "$target_path"; then
    continue
  fi

  changed_files=$((changed_files + 1))
  total_changed_lines=$((total_changed_lines + added + deleted))
done < "$tmp_file"

rm -f "$tmp_file"

printf '{\n'
printf '  "changed_files": %s,\n' "$changed_files"
printf '  "total_changed_lines": %s\n' "$total_changed_lines"
printf '}\n'
