# dotfiles

Personal macOS shell setup. Setup a fresh laptop with one command.

## Project structure

- `config.sh` — bootstrap script; symlinks the files below into `$HOME`.
- `.zshrc` — shell config, plus a first-run block that installs Homebrew, brew formulas, Oh My Zsh + plugins, and Node LTS.
- `.gitconfig` — git config (editor, default branch, user).
- `.gitignore` — global ignore rules (e.g. `.DS_Store`).

## Install

```sh
git clone https://github.com/v4ldimar/dotfiles.git ~/dotfiles
~/dotfiles/config.sh
exec zsh
```

- `config.sh` symlinks `.zshrc`, `.gitconfig`, and `.gitignore` into `$HOME`.
- Existing files are saved to `*.bak`.

**The first zsh launch installs everything that's missing:**

- Homebrew
- Brew formulas: `git`, `neovim`, `nvm`, `powerlevel10k`
- Oh My Zsh + plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions`)
- Node LTS via nvm

Subsequent shell startups are silent — each step checks if it's already installed.

## Update

- Edit files in `~/dotfiles` directly the symlinks pick up changes immediately.
- To install a new tool, add it to the brew bootstrap block in [.zshrc](.zshrc).
