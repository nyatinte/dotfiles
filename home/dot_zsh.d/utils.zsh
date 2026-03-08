# 長時間コマンドの完了通知
notify-after() {
  "$@"
  local exit_code=$?
  if [ $exit_code -eq 0 ]; then
    cmux notify --title "✓ Command Complete" --body "$1"
  else
    cmux notify --title "✗ Command Failed" --body "$1 (exit $exit_code)"
  fi
  return $exit_code
}
