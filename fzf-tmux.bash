__fzf_tmux_fzf() {
	# Refer to
	# https://github.com/junegunn/fzf-git.sh/blob/main/README.md#customization
	# for more information about _fzf_git_fzf.
	_fzf_git_fzf --bind=ctrl-z:ignore "$@"
}

_fzf_tmux_capture_pane_lines() {
	tmux capture-pane -e -p -J |
		sed --expression='/^$/d' |
		head --lines=-1 |
		uniq |
		__fzf_tmux_fzf --ansi --multi --tac \
		--header=$'ALT-E (open in editor)\n\n' \
		--bind="alt-e:execute:${EDITOR:-vim} {-1} > /dev/tty" |
		sed --expression='s/^[[:space:]]*//' --expression='s/[[:space:]]*$//'
}

# Inspired by https://unix.stackexchange.com/a/533667.
_fzf_tmux_capture_pane_words() {
	tmux capture-pane -e -p -J |
		sed --expression='/^$/d' |
		head --lines=-1 |
		uniq |
		grep --only-matching \
		--perl-regexp '\s*[^\s]+\s*' |
		awk '{ if (seen_words[$0]++ == 0) { print $0; } }' |
		__fzf_tmux_fzf --ansi --multi --tac \
		--header=$'ALT-E (open in editor)\n\n' \
		--bind="alt-e:execute:${EDITOR:-vim} {-1} > /dev/tty"
}
