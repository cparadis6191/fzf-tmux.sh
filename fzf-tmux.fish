function __fzf_tmux_fish
    commandline --insert (eval $argv | string join ' ')
end

bind \cx\cl '__fzf_tmux_fish _fzf_tmux_capture_pane_lines'
bind \cx\cf '__fzf_tmux_fish _fzf_tmux_capture_pane_words'

bind \cxl '__fzf_tmux_fish _fzf_tmux_capture_pane_lines'
bind \cxf '__fzf_tmux_fish _fzf_tmux_capture_pane_words'
