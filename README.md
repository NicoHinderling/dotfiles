# dotfiles

My zsh + [Ghostty](https://ghostty.org) setup on macOS.

- `.zshrc`: oh-my-zsh with a two-dir prompt and a desktop notification when a command runs longer than 5s
- `aliases.zsh`: git helpers like `branchtinder` (swipe through local branches to delete), `del-old` (delete branches already squash-merged), `rbm` (rebase on fresh main/master) and `b` (branches by recent commit)
- `ghostty/config`: jump between prompts, copy-on-select, Option+Arrow word movement, Shift+Arrow selection via [zsh-shift-select](https://github.com/jirutka/zsh-shift-select)

Clone to `~/dotfiles`, then symlink `.zshrc` and `ghostty/config` into place.
