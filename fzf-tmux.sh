# The MIT License (MIT)
#
# Copyright (c) 2024 Junegunn Choi
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# shellcheck disable=SC2039
[[ $0 = - ]] && return

if [[ $- =~ i ]] || [[ $1 = --run ]]; then # ----------------------------------

if [[ $_fzf_tmux_fzf ]]; then
  eval "$_fzf_tmux_fzf"
else
  # Redefine this function to change the options
  _fzf_tmux_fzf() {
    fzf --height 50% --tmux 90%,70% \
      --layout reverse --multi --min-height 20+ --border \
      --no-separator --header-border horizontal \
      --border-label-pos 2 \
      --color 'label:blue' \
      --preview-window 'right,50%' --preview-border line \
      --bind 'ctrl-/:change-preview-window(down,50%|hidden|)' "$@"
  }
fi

__fzf_tmux=${BASH_SOURCE[0]:-${(%):-%x}}
__fzf_tmux=$(readlink -f "$__fzf_tmux" 2> /dev/null || /usr/bin/ruby --disable-gems -e 'puts File.expand_path(ARGV.first)' "$__fzf_tmux" 2> /dev/null)

_fzf_tmux_lpane_lines() {
	tmux capture-pane -J -e -p |
		sed --expression='/^$/d' |
		head --lines=-1 |
		uniq |
		_fzf_tmux_fzf --ansi \
		--multi \
		--tac \
		--header=$'ALT-E (open in editor)\n' \
		--bind="alt-e:execute:${EDITOR:-vim} {-1} > /dev/tty" |
		sed --expression='s/^[[:space:]]*//' --expression='s/[[:space:]]*$//'
}

# Inspired by https://unix.stackexchange.com/a/533667.
_fzf_tmux_fpane_words() {
	tmux capture-pane -J -e -p |
		sed --expression='/^$/d' |
		head --lines=-1 |
		uniq |
		grep --only-matching \
		--perl-regexp '\s*[^\s]+\s*' |
		awk '{ if (seen_words[$0]++ == 0) { print $0; } }' |
		sed --expression='s/^\s\+//' --expression='s/\s\+$//' |
		_fzf_tmux_fzf --ansi \
		--multi \
		--tac \
		--header=$'ALT-E (open in editor)\n' \
		--bind="alt-e:execute:${EDITOR:-vim} {+} > /dev/tty"
}

_fzf_tmux_list_bindings(){
  cat <<'EOF'

CTRL-X ? to show this list
CTRL-X CTRL-F for Words
CTRL-X CTRL-B for Lines
EOF
}

fi # --------------------------------------------------------------------------

if [[ $1 = --run ]]; then
  shift
  type=$1
  shift
  eval "_fzf_tmux_$type" "$@"

elif [[ $- =~ i ]]; then # ------------------------------------------------------
if [[ -n "${BASH_VERSION:-}" ]]; then
  __fzf_tmux_init() {
    bind -m emacs-standard '"\er":  redraw-current-line'
    bind -m emacs-standard '"\C-z": vi-editing-mode'
    bind -m vi-command     '"\C-z": emacs-editing-mode'
    bind -m vi-insert      '"\C-z": emacs-editing-mode'

    local o c
    for o in "$@"; do
      c=${o:0:1}
      if [[ $c == '?' ]]; then
        bind -x '"\C-x'$c'": _fzf_tmux_list_bindings'
        continue
      fi
      bind -m emacs-standard '"\C-x\C-'$c'": " \C-u \C-a\C-k`_fzf_tmux_'$o'`\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er \C-h"'
      bind -m vi-command     '"\C-x\C-'$c'": "\C-z\C-x\C-'$c'\C-z"'
      bind -m vi-insert      '"\C-x\C-'$c'": "\C-z\C-x\C-'$c'\C-z"'
      bind -m emacs-standard '"\C-x'$c'":    " \C-u \C-a\C-k`_fzf_tmux_'$o'`\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er \C-h"'
      bind -m vi-command     '"\C-x'$c'":    "\C-z\C-x'$c'\C-z"'
      bind -m vi-insert      '"\C-x'$c'":    "\C-z\C-x'$c'\C-z"'
    done
  }
elif [[ -n "${ZSH_VERSION:-}" ]]; then
  __fzf_tmux_join() {
    local item
    while read item; do
      echo -n "${(q)item} "
    done
  }

  __fzf_tmux_init() {
    setopt localoptions nonomatch
    local m o
    for o in "$@"; do
      if [[ ${o[1]} == "?" ]];then
        eval "fzf-tmux-$o-widget() { zle -M '$(_fzf_tmux_list_bindings)' }"
      else
        eval "fzf-tmux-$o-widget() { local result=\$(_fzf_tmux_$o | __fzf_tmux_join); zle reset-prompt; LBUFFER+=\$result }"
      fi
      eval "zle -N fzf-tmux-$o-widget"
      for m in emacs vicmd viins; do
        eval "bindkey -M $m '^g^${o[1]}' fzf-tmux-$o-widget"
        eval "bindkey -M $m '^g${o[1]}' fzf-tmux-$o-widget"
      done
    done
  }
fi
__fzf_tmux_init fpane_words lpane_lines '?list_bindings'

fi # --------------------------------------------------------------------------
