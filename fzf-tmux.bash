# tmux heart fzf
# -------------

__fzf_tmux_cmd() {
  # Refer to
  # https://github.com/junegunn/fzf/blob/master/shell/key-bindings.bash for
  # more information about __fzfcmd.
  $(__fzfcmd) --bind=ctrl-z:ignore "$@"
}

_fzf_tmux_capture_pane() {
	tmux capture-pane -e -p -J | sed --expression='/^$/d' | head --lines=-1 | uniq | sed --expression='s/^[[:space:]]*//' --expression='s/[[:space:]]*$//' | __fzf_tmux_cmd --ansi --layout=default --multi --tac
}
