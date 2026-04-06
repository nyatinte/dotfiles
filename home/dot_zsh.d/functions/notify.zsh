# 長時間コマンドの完了通知
notify-after() {
	"$@"
	local exit_code=$?
	if (( exit_code == 0 )); then
		cmux notify --title "✓ Command Complete" --body "$*"
	else
		cmux notify --title "✗ Command Failed" --body "$* (exit $exit_code)"
	fi
	return $exit_code
}
