#!/bin/zsh

set -euo pipefail

# Reload user abbreviations after chezmoi apply.
# This primes zsh-abbr for newly spawned shells, but does not mutate
# already-running interactive sessions.
zsh -ic '
if command -v abbr >/dev/null 2>&1; then
  abbr load >/dev/null 2>&1 || true
fi
' >/dev/null 2>&1 || true
