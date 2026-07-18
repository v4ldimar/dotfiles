# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal macOS shell dotfiles. Goal: set up a fresh machine with one command.

## Commands

- Install: `./config.sh`, then `exec zsh`.
- No build, lint, test, or CI tooling exists in this repo (no Makefile, package.json, or .github/workflows) — don't go looking for one.

## Architecture

The setup is split across two stages:

- **`config.sh`** only symlinks three static files (`.gitconfig`, `.gitignore`, `.zshrc`) from the repo into `$HOME`, backing up any pre-existing real file to `<file>.bak` first. It does not install any tools itself.
- **`.zshrc`** contains a first-run bootstrap block (top of the file) that installs everything else: Homebrew, brew formulas (`git`, `neovim`, `nvm`, `powerlevel10k`), Oh My Zsh + plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions`), and Node LTS via nvm. This block runs on every new shell but is idempotent — each step checks whether it's already installed before acting, so it's silent after the first run.

Because `.zshrc` is symlinked rather than copied, editing files in this repo takes effect immediately in new shells. There's no separate "reinstall" step for config changes — only adding a genuinely new tool requires touching the bootstrap block in `.zshrc`.

`~/.p10k.zsh` is sourced by `.zshrc` if present but is not tracked in this repo — it's generated locally via `p10k configure`.

## Bash scripting conventions

When writing or editing bash scripts in this repo (`config.sh` or any new script), follow these conventions:

- **Header**: start with `#!/usr/bin/env bash` and `set -euo pipefail`.
- **Quoting & tests**: always quote variables (`"$var"`); use `[[ ]]` not `[ ]`; use `(( ))` for arithmetic.
- **Variables**: `local` inside functions; `readonly UPPERCASE` for constants; `${var:-default}` / `${var:?error message}` for optional/required values.
- **Errors**: use a `die() { echo "$0: error: $*" >&2; exit 1; }` helper for fatal errors; use `trap ... EXIT` to clean up any temp files.
- **Idempotency**: check whether a step is already done before acting — the pattern `.zshrc`'s bootstrap block and `config.sh`'s symlink loop already follow.
- **Iteration safety**: read lines with `while IFS= read -r line; do ...; done < "$file"`; guard globs with `[[ -e "$f" ]] || continue`.
- **If a script grows arguments**: support `-h`/`--help`, fail on unknown flags, and exit `0` (success) / `1` (general error) / `2` (invalid usage). Not required for argument-less scripts like `config.sh` today.

Run `shellcheck -s bash <script>` before committing changes to any script.

## Keeping docs in sync

Whenever changes are made to the core dotfiles or scripts (see [Project structure](README.md#project-structure) in `README.md`), update `README.md` and/or `CLAUDE.md` to reflect those changes — but only if the diff is relevant to what these docs describe (install steps, bootstrap behavior, symlinked files, tools installed). Don't touch the docs for changes that don't affect their content.
