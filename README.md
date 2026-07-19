# dotfiles

My personal macOS shell setup. One command, fresh laptop, working shell.

## Project structure

- `config.sh`: symlinks the files below into `$HOME`.
- `.zshrc`: shell config; installs Homebrew & packages, Oh My Zsh + plugins, and Node LTS on first run.
- `.gitconfig`: git config global settings (editor, default branch, user).
- `.gitignore`: git ignore global rules.

## Install

```sh
git clone https://github.com/v4ldimar/dotfiles.git && cd dotfiles && exec zsh
```

- Existing files get saved & backed up to `*.bak` first.
- On the first zsh launch it installs whatever's missing:
  - MacOS: `git`/`neovim`/`nvm`/`powerlevel10k`, Oh My Zsh + plugins, Node LTS.

## Updating

- Edit files in `~/dotfiles` directly. They are symlinked so changes apply right away.
- To add a new tool, drop it in the install block at the top of [.zshrc](.zshrc).
