# 長時間コマンドの完了通知
notify-after() {
	"$@"
	local exit_code=$?
	if ((exit_code == 0)); then
		osascript -e "display notification \"$*\" with title \"✓ Command Complete\""
	else
		osascript -e "display notification \"$* (exit $exit_code)\" with title \"✗ Command Failed\""
	fi
	return $exit_code
}
