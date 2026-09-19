#!/bin/bash
set -euo pipefail

# Restore globally-installed agent skills on a new machine.
#
# Skills are managed by the `skills` CLI (https://skills.sh); chezmoi only keeps
# the lock file in sync (home/dot_agents/dot_skill-lock.json -> ~/.agents/.skill-lock.json).
# This script replays the lock file so the installed set matches the lock.

lock="${HOME}/.agents/.skill-lock.json"

if ! command -v skills >/dev/null 2>&1; then
	echo "skills CLI not found in PATH; skipping skill restore" >&2
	exit 0
fi

if ! command -v jq >/dev/null 2>&1; then
	echo "jq not found in PATH; skipping skill restore" >&2
	exit 0
fi

if [ ! -f "$lock" ]; then
	echo "No skill lock file at ${lock}; skipping skill restore" >&2
	exit 0
fi

jq -r '.skills | to_entries[] | "\(.value.source)\t\(.key)"' "$lock" |
	while IFS=$'\t' read -r source name; do
		[ -z "${source}" ] && continue
		echo "Installing skill: ${name} (${source})"
		skills add "${source}" --skill "${name}" -g -y ||
			echo "Failed to install skill: ${name}" >&2
	done
