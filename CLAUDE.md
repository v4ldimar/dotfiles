# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal shell dotfiles for macOS (zsh) and Windows (Git Bash). Goal: set up a fresh machine with one command.

## Commands

- Install (macOS): `./install.sh`, then `exec zsh`.
- Install (Windows): `./install.ps1` from PowerShell.
- No build, lint, test, or CI tooling exists in this repo (no Makefile, package.json, or .github/workflows) — don't go looking for one.

## Architecture

`install.sh` is the entry point on both platforms — it detects the OS via `uname -s` and dispatches to the platform-specific config script. On Windows, if it's launched from a context with no bash at all yet, `install.ps1` is a thin PowerShell shim that installs Git for Windows via winget (which bundles Git Bash) and then hands off to `install.sh`.

Each platform's setup is split across two stages, symlink installer + shell-config bootstrap:

- **macOS**: **`config.sh`** only symlinks three static files (`.gitconfig`, `.gitignore`, `.zshrc`) from the repo into `$HOME`, backing up any pre-existing real file to `<file>.bak` first. It does not install any tools itself. **`.zshrc`** contains a first-run bootstrap block (top of the file) that installs everything else: Homebrew, brew formulas (`git`, `neovim`, `nvm`, `powerlevel10k`), Oh My Zsh + plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions`), and Node LTS via nvm.
- **Windows**: **`config.ps1`** is the PowerShell equivalent of `config.sh` — symlinks `.gitconfig`, `.gitignore`, `.bashrc` into `$HOME` (via `New-Item -ItemType SymbolicLink`, which needs Developer Mode on or an elevated shell), backing up any pre-existing real file the same way. **`.bashrc`** is the Windows equivalent of `.zshrc` — its first-run bootstrap block installs nvm (git-cloned into `~/.nvm`), Node LTS via nvm, and Neovim via winget, plus the shared aliases. There's no Oh My Zsh/powerlevel10k equivalent on Windows — it's intentionally scoped down to git config, nvm, Neovim, and aliases.

Both bootstrap blocks run on every new shell but are idempotent — each step checks whether it's already installed before acting, so they're silent after the first run.

Because `.zshrc`/`.bashrc` are symlinked rather than copied, editing files in this repo takes effect immediately in new shells. There's no separate "reinstall" step for config changes — only adding a genuinely new tool requires touching the bootstrap block in the relevant file.

`~/.p10k.zsh` is sourced by `.zshrc` if present but is not tracked in this repo — it's generated locally via `p10k configure`. It has no Windows equivalent.

## Bash scripting conventions

When writing or editing bash scripts in this repo (`config.sh`, `install.sh`, `.bashrc`, or any new script), follow these conventions. `config.ps1` and `install.ps1` are PowerShell, not bash, so these conventions don't apply to them directly — but keep the same spirit: validate/back up before mutating, check-before-install idempotency, fail with a clear message.

- **Header**: start with `#!/usr/bin/env bash` and `set -euo pipefail`.
- **Quoting & tests**: always quote variables (`"$var"`); use `[[ ]]` not `[ ]`; use `(( ))` for arithmetic.
- **Variables**: `local` inside functions; `readonly UPPERCASE` for constants; `${var:-default}` / `${var:?error message}` for optional/required values.
- **Errors**: use a `die() { echo "$0: error: $*" >&2; exit 1; }` helper for fatal errors; use `trap ... EXIT` to clean up any temp files.
- **Idempotency**: check whether a step is already done before acting — the pattern `.zshrc`'s bootstrap block and `config.sh`'s symlink loop already follow.
- **Iteration safety**: read lines with `while IFS= read -r line; do ...; done < "$file"`; guard globs with `[[ -e "$f" ]] || continue`.
- **If a script grows arguments**: support `-h`/`--help`, fail on unknown flags, and exit `0` (success) / `1` (general error) / `2` (invalid usage). Not required for argument-less scripts like `config.sh` today.

Run `shellcheck -s bash <script>` before committing changes to any script.

## Keeping docs in sync

Whenever changes are made to the core dotfiles or scripts (see [What's here](README.md#whats-here) in `README.md`), update `README.md` and/or `CLAUDE.md` to reflect those changes — but only if the diff is relevant to what these docs describe (install steps, bootstrap behavior, symlinked files, tools installed). Don't touch the docs for changes that don't affect their content.
