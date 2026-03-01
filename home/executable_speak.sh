#!/bin/bash
# VOICEVOX zundamon TTS script.
# Reads text from stdin, synthesizes speech via VOICEVOX API, and plays it.

VOICEVOX_URL="http://localhost:50021"
SPEAKER=3
MAX_LEN=200

TEXT=$(cat - | tr '\n' ' ')

if [ -z "$TEXT" ]; then
  TEXT="タスクが終わったのだ！"
fi

if [ "${#TEXT}" -gt "$MAX_LEN" ]; then
  TEXT="${TEXT:0:180}...続きは画面見てなのだ！"
fi

echo "$(date): spoke: $TEXT" >> /tmp/czths.log

ENCODED=$(printf '%s' "$TEXT" | jq -Rr @uri)

RESPONSE=$(curl -s -w "\n%{http_code}" "${VOICEVOX_URL}/audio_query?text=${ENCODED}&speaker=${SPEAKER}")
HTTP_STATUS=$(echo "$RESPONSE" | tail -1)
QUERY_BODY=$(echo "$RESPONSE" | head -n -1)

if [ "$HTTP_STATUS" != "200" ]; then
  echo "$(date): audio_query failed with $HTTP_STATUS" >> /tmp/czths.log
  exit 1
fi

WAV_FILE="/tmp/zunda_$(date +%s).wav"
HTTP_STATUS=$(curl -s -o "$WAV_FILE" -w "%{http_code}" \
  -X POST "${VOICEVOX_URL}/synthesis?speaker=${SPEAKER}" \
  -H "Content-Type: application/json" \
  -d "$QUERY_BODY")

if [ "$HTTP_STATUS" != "200" ]; then
  echo "$(date): synthesis failed with $HTTP_STATUS" >> /tmp/czths.log
  rm -f "$WAV_FILE"
  exit 1
fi

if command -v afplay &>/dev/null; then
  afplay "$WAV_FILE"
elif command -v aplay &>/dev/null; then
  aplay -q "$WAV_FILE"
elif command -v pw-cat &>/dev/null; then
  pw-cat --playback "$WAV_FILE"
fi

rm -f "$WAV_FILE"
