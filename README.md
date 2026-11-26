# dotfiles

My personal shell setup for macOS (zsh) and Windows (Git Bash). One command, fresh machine, working shell.

## What's here

- `install.sh` / `install.ps1`: entry point — detects the OS and runs the matching installer below.
- `config.sh` / `config.ps1`: symlinks the files below into your home directory.
- `bin/odysseus`: forwards to `~/scripts/odysseus/odysseus.sh`; `.zshrc` adds `bin` to your PATH.
- `.zshrc`: macOS shell config; installs Homebrew & packages, Oh My Zsh + plugins, and Node LTS on first run.
- `.bashrc`: Windows/Git Bash shell config; installs nvm, Node LTS, and Neovim on first run.
- `.gitconfig`: git settings (editor, default branch, user).
- `.gitignore`: global ignore rules.

## Install

Clone it wherever you like — the scripts symlink based on their own location, not where the repo lives.

macOS:

```sh
git clone https://github.com/v4ldimar/dotfiles.git && cd dotfiles && bash install.sh && exec zsh
```

Windows (PowerShell):

```powershell
git clone https://github.com/v4ldimar/dotfiles.git; cd dotfiles; powershell -ExecutionPolicy Bypass -File install.ps1
```

Existing files get backed up to `*.bak` first. On Windows, creating the symlinks needs Developer Mode on (Settings > Privacy & Security > For developers) or an elevated PowerShell.

## Odysseus

Setup and model selection live in the [scripts repository](https://github.com/v4ldimar/scripts), under `odysseus/`. Clone it at `~/scripts`, then run:

```sh
odysseus --setup
odysseus
```

The launcher detects Apple Silicon versus 64-bit Linux/Intel Mac, uses llmfit for model sizing, and offers an optional clickable app on Apple Silicon. See `~/scripts/odysseus/README.md` for dependencies and Raspberry Pi usage.

## Updating

Edit files in the cloned repo directly — they're symlinked, so changes apply right away. To add a new tool, drop it in the install block at the top of `.zshrc` or `.bashrc`.
