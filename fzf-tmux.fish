function _fzf_tmux_sh
    # Get the absolute path to the parent directory of this script (i.e. the
    # parent directory of fzf-tmux.sh) to use in the key bindings to avoid
    # having to modify `$PATH`.
    set --function fzf_tmux_sh_path (realpath (status dirname))

    SHELL=bash bash $fzf_tmux_sh_path/fzf-tmux.sh --run $argv
end

set --local commands fpane_words lpane_lines

for command in $commands
    set --function key (string sub --length=1 $command)

    eval "function _fzf_tmux_$command; _fzf_tmux_sh $command; end"

    eval "bind --mode default \cx$key   'commandline --insert (_fzf_tmux_$command | string join \" \")'"
    eval "bind --mode insert  \cx$key   'commandline --insert (_fzf_tmux_$command | string join \" \")'"
    eval "bind --mode default \cx\c$key 'commandline --insert (_fzf_tmux_$command | string join \" \")'"
    eval "bind --mode insert  \cx\c$key 'commandline --insert (_fzf_tmux_$command | string join \" \")'"
end
