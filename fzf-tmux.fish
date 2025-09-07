function _fzf_tmux_sh
    # Get the absolute path to the parent directory of this script (i.e. the
    # parent directory of fzf-tmux.sh) to use in the key bindings to avoid
    # having to modify `$PATH`.
    set --function fzf_tmux_sh_path (realpath (status dirname))

    SHELL=bash bash $fzf_tmux_sh_path/fzf-tmux.sh --run $argv
end

set --local commands fcapture_pane_words lcapture_pane_lines

for command in $commands
    set --function key (string sub --length=1 $command)

    eval "bind --mode default \cx$key   'commandline --insert (_fzf_tmux_sh $command | string join \" \")'"
    eval "bind --mode insert  \cx$key   'commandline --insert (_fzf_tmux_sh $command | string join \" \")'"
    eval "bind --mode default \cx\c$key 'commandline --insert (_fzf_tmux_sh $command | string join \" \")'"
    eval "bind --mode insert  \cx\c$key 'commandline --insert (_fzf_tmux_sh $command | string join \" \")'"
end
