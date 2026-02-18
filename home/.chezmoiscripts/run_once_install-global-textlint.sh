#!/bin/bash

set -euo pipefail

# Install textlint and Japanese technical writing rules globally
# Rules: https://github.com/textlint-ja/textlint-rule-preset-ja-technical-writing
pnpm add -g \
  textlint \
  textlint-rule-preset-ja-technical-writing
