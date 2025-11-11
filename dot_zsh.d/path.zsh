# WHY: https://zenn.dev/sprout2000/articles/bd1fac2f3f83bc
typeset -U path PATH

export PROTO_HOME="$HOME/.proto"
path=(
  $PROTO_HOME/shims
  $PROTO_HOME/bin
  $PROTO_HOME/tools/node/globals/bin
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /usr/bin
  /usr/sbin
  /bin
  /sbin
  /usr/local/bin
  /usr/local/sbin
  /Library/Apple/usr/bin
  $HOME/.local/bin
  $HOME/.bun/bin
)
