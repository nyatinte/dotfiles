#!/bin/bash
# Claude Code hook entry point for VOICEVOX zundamon voice notifications.
# Receives JSON on stdin, dispatches text to ~/speak.sh in background.

INPUT=$(cat -)
HOOK_EVENT=$(echo "$INPUT" | jq -r '.hook_event_name')

case "$HOOK_EVENT" in
  "Stop")
    TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path')
    if [ -f "$TRANSCRIPT" ]; then
      TEXT=$(jq -rn '[inputs | select(.type == "assistant") | .message.content[] | select(.type == "text") | .text] | last' "$TRANSCRIPT")
    fi
    echo "$TEXT" | ~/speak.sh &
    ;;
  "Notification")
    TEXT=$(echo "$INPUT" | jq -r '.message')
    echo "$TEXT" | ~/speak.sh &
    ;;
esac

exit 0
