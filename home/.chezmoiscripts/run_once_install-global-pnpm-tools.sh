#!/bin/bash

set -euo pipefail

# CLI tools that used to be installed by mise (npm backend).
# `skills` must be present before run_once_install-global-skills.sh runs.
pnpm add -g \
	difit \
	ccusage \
	portless \
	skills \
	agent-browser \
	markdownlint-cli2 \
	@antfu/ni \
	@nyatinte/prw
