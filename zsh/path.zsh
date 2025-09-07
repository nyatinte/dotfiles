# PATH設定
# https://zenn.dev/sprout2000/articles/bd1fac2f3f83bc

typeset -U path PATH

# Protoを最優先にする
export PROTO_HOME="$HOME/.proto"
path=(
  $PROTO_HOME/shims(N-/)
  $PROTO_HOME/bin(N-/)
  /opt/homebrew/bin(N-/)
  /opt/homebrew/sbin(N-/)
  /usr/bin
  /usr/sbin
  /bin
  /sbin
  /usr/local/bin(N-/)
  /usr/local/sbin(N-/)
  /Library/Apple/usr/bin
  $HOME/.local/bin
)

