fzf-tmux.sh
==========

bash, zsh, and fish key bindings for tmux objects, powered by [fzf][fzf].

Each binding will allow you to browse through tmux objects of a certain type,
and select the objects you want to paste to your command-line.

[fzf]: https://github.com/junegunn/fzf

Installation
------------

* Install the latest version of [fzf][fzf]
* Update your shell configuration file
    * bash or zsh
        * Source [fzf-tmux.sh](https://raw.githubusercontent.com/junegunn/fzf-tmux.sh/main/fzf-tmux.sh) file from your .bashrc or .zshrc
    * fish
        * Source [fzf-tmux.fish](https://raw.githubusercontent.com/junegunn/fzf-tmux.sh/main/fzf-tmux.fish) from your config.fish

Usage
-----

### List of bindings

* <kbd>CTRL-X</kbd><kbd>?</kbd> to show this list
* <kbd>CTRL-X</kbd><kbd>CTRL-F</kbd> to **F**ind tmux pane words
* <kbd>CTRL-X</kbd><kbd>CTRL-L</kbd> for tmux pane **L**ines

> [!WARNING]
> If zsh's `KEYTIMEOUT` is too small (e.g. 1), you may not be able
> to hit two keys in time.

### Inside fzf

* <kbd>TAB</kbd> or <kbd>SHIFT-TAB</kbd> to select multiple objects
* <kbd>CTRL-/</kbd> to change preview window layout

Customization
-------------

```sh
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
```

Defining shortcut commands
--------------------------

Each binding is backed by `_fzf_tmux_*` function so you can do something like
this in your shell configuration file.

```sh
tl() {
  _fzf_tmux_fpane_words
}

tw() {
  cd "$(_fzf_tmux_lpane_lines)"
}
```

In fish, each binding is backed by `__fzf_git_sh *` so you can do something
like this this in your shell configuration file.

```fish
function tw
  _fzf_tmux_fpane_words
end

function tsl
  cd (_fzf_tmux_lpane_lines)
end
```

Environment Variables
---------------------

| Variable                | Description                                              | Default                                         |
| ----------------------- | -------------------------------------------------------- | ----------------------------------------------- |
| `BAT_STYLE`             | Specifies the style for displaying files using `bat`     | `full`                                          |
