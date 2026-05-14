# dotfiles

Personal macOS shell setup. Setup a fresh laptop with one command.

## Install

```sh
git clone https://github.com/v4ldimar/dotfiles.git ~/dotfiles
~/dotfiles/config.sh
exec zsh
```

`config.sh` symlinks `.zshrc`, `.gitconfig`, and `.gitignore` into `$HOME` (existing files are saved to `*.bak`). The first zsh launch then bootstraps everything that's missing:

- Homebrew
- Brew formulas: `git`, `neovim`, `nvm`, `powerlevel10k`
- Oh My Zsh + plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions`)
- Node LTS via nvm

Subsequent shell startups are silent — each step checks if it's already installed.

## Update

Edit files in `~/dotfiles` directly; the symlinks pick up changes immediately. To install a new tool, add it to the brew bootstrap block in [.zshrc](.zshrc).
