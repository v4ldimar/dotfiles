# ===== tool install scripts =====

# nvm (first-run only)
export NVM_DIR="$HOME/.nvm"
if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
  echo "==> Installing nvm"
  git clone --depth=1 https://github.com/nvm-sh/nvm.git "$NVM_DIR"
fi
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

# Node LTS via nvm (first-run only)
if [[ ! -s "$NVM_DIR/alias/default" ]]; then
  echo "==> Installing Node LTS"
  nvm install --lts
  nvm alias default 'lts/*'
fi

# Neovim (first-run only, best-effort via winget)
if ! command -v nvim >/dev/null 2>&1; then
  if command -v winget >/dev/null 2>&1; then
    echo "==> Installing Neovim"
    winget install --id Neovim.Neovim -e --source winget \
      --accept-package-agreements --accept-source-agreements
    if ! command -v nvim >/dev/null 2>&1; then
      echo "==> Neovim installed but not on PATH in this session yet — open a new terminal to use it."
    fi
  else
    echo "winget not found; install Neovim manually: https://github.com/neovim/neovim/releases"
  fi
fi
# === end tool install scripts ===

# Aliases
alias vim='nvim'
