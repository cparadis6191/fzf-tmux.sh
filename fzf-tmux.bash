# tmux heart fzf
# -------------

__fzf_tmux_cmd() {
	# Refer to
	# https://github.com/junegunn/fzf/blob/master/shell/key-bindings.bash for
	# more information about __fzfcmd.
	$(__fzfcmd) --bind=ctrl-z:ignore "$@"
}

_fzf_tmux_capture_pane_lines() {
	tmux capture-pane -e -p -J |
		sed --expression='/^$/d' |
		head --lines=-1 |
		uniq |
		__fzf_tmux_cmd --ansi --layout=default --multi --tac |
		sed --expression='s/^[[:space:]]*//' --expression='s/[[:space:]]*$//'
}

# Inspired by https://unix.stackexchange.com/a/533667.
_fzf_tmux_capture_pane_words() {
	tmux capture-pane -e -p -J |
		sed --expression='/^$/d' |
		head --lines=-1 |
		uniq |
		grep --only-matching --perl-regexp '\s*[^\s]+\s*' |
		awk '{ if (seen_words[$0]++ == 0) { print $0; } }' |
		__fzf_tmux_cmd --ansi --layout=default --multi --tac
}
