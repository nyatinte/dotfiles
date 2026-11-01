# Shell options and history
# WHY: https://zsh.sourceforge.io/Doc/Release/Options.html

# --- History ---
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt EXTENDED_HISTORY     # save timestamp and execution time
setopt SHARE_HISTORY        # share history across terminals in real time
setopt HIST_IGNORE_ALL_DUPS # drop older duplicates instead of piling up
setopt HIST_IGNORE_SPACE    # commands prefixed with a space are not recorded
setopt HIST_REDUCE_BLANKS   # strip superfluous blanks
setopt HIST_VERIFY          # show the expansion before running it

# --- Basics ---
setopt AUTO_CD    # `foo` instead of `cd foo`
setopt AUTO_PUSHD # cd pushes the previous directory onto the stack
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt INTERACTIVE_COMMENTS # allow `# comment` in interactive shells
setopt NO_BEEP
