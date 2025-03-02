function __fzf_tmux_fish
    commandline --insert (eval $argv[1] | string join ' ')
end

bind \cx\cl '__fzf_tmux_fish _fzf_tmux_capture_pane_lines'
bind \cx\cf '__fzf_tmux_fish _fzf_tmux_capture_pane_words'
