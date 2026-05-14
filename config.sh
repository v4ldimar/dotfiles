#!/bin/bash
# Symlink dotfiles into $HOME. The .zshrc itself bootstraps Homebrew,
# Oh My Zsh, plugins, and nvm on first shell load.

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for file in .gitconfig .gitignore .zshrc; do
  target="$HOME/$file"
  if [[ -e "$target" && ! -L "$target" ]]; then
    mv "$target" "$target.bak"
    echo "backed up existing $file to $file.bak"
  fi
  ln -sfn "$REPO/$file" "$target"
done

if [[ "${SHELL:-}" != *zsh ]]; then
  echo "Default shell is not zsh. Run: chsh -s /bin/zsh"
fi

echo "Done. Open a new terminal — first launch will install Homebrew, Oh My Zsh, plugins, and Node LTS."
