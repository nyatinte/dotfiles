#!/bin/bash

set -euo pipefail

# Install textlint and Japanese writing rules globally
# Rules: https://github.com/textlint-ja/textlint-rule-preset-ja-technical-writing
#        https://github.com/textlint-ja/textlint-rule-preset-ai-writing
pnpm add -g \
  textlint \
  textlint-rule-preset-ja-technical-writing \
  @textlint-ja/textlint-rule-preset-ai-writing
