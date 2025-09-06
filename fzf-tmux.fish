function __fzf_tmux_sh
    # Get the absolute path to the parent directory of this script (i.e. the
    # parent directory of fzf-tmux.sh) to use in the key bindings to avoid
    # having to modify `$PATH`.
    set --function fzf_tmux_sh_path (realpath (status dirname))

    commandline --insert (SHELL=bash bash "$fzf_tmux_sh_path/fzf-tmux.sh" --run $argv | string join ' ')
end

set --local commands fcapture_pane_words lcapture_pane_lines

for command in $commands
    set --function key (string sub --length=1 $command)

    eval "bind -M default \cx$key   '__fzf_tmux_sh $command'"
    eval "bind -M insert  \cx$key   '__fzf_tmux_sh $command'"
    eval "bind -M default \cx\c$key '__fzf_tmux_sh $command'"
    eval "bind -M insert  \cx\c$key '__fzf_tmux_sh $command'"
end
