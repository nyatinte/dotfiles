#!/bin/bash
# Usage: notify.sh <notification_type>
# Example
# ---
# "hooks": {
#   "Notification": [
#     {
#       "matcher": "permission_prompt",
#       "hooks": [
#         {
#           "type": "command",
#           "command": "~/.claude/hooks/notify.sh permission_prompt"
#         }
#       ]
#     },
#     {
#       "matcher": "idle_prompt",
#       "hooks": [
#         {
#           "type": "command",
#           "command": "~/.claude/hooks/notify.sh idle_prompt"
#         }
#       ]
#     }
#   ],
#   "Stop": [
#     {
#       "hooks": [
#         {
#           "type": "command",
#           "command": "~/.claude/hooks/notify.sh complete"
#         }
#       ]
#     }
#   ],
#   "PostToolUse": [
#     {
#       "matcher": "Task",
#       "hooks": [
#         {
#           "type": "command",
#           "command": "~/.claude/hooks/cmux-notify.sh"
#           "command": "~/.claude/hooks/notify.sh post_tool_use"
#         }
#       ]
#     }
#   ]
# },

[ -S /tmp/cmux.sock ] || exit 0

PROJECT_NAME=$(basename "$PWD")
NOTIFICATION_TYPE="$1"

case "$NOTIFICATION_TYPE" in
  "permission_prompt")
    cmux notify --title 'Claude Code 🔔' --subtitle "$PROJECT_NAME" --body '承認をお待ちしています'
    afplay /System/Library/Sounds/Glass.aiff
    ;;
  "idle_prompt")
    cmux notify --title 'Claude Code 💬' --subtitle "$PROJECT_NAME" --body '入力待ちです'
    afplay /System/Library/Sounds/Ping.aiff
    ;;
  "post_tool_use")
    cmux notify --title 'Claude Code 🤖' --subtitle "$PROJECT_NAME" --body 'エージェントが完了しました'
    afplay /System/Library/Sounds/Purr.aiff
    ;;
  "complete")
    cmux notify --title 'Claude Code ✅' --subtitle "$PROJECT_NAME" --body 'タスクが完了しました'
    open -g 'raycast://extensions/raycast/raycast/confetti?emojis=🎉🎉🎉'
    afplay /System/Library/Sounds/Hero.aiff
    ;;
esac
