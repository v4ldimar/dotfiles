#!/usr/bin/env bash
# Detect the OS and hand off to the right platform installer:
# macOS -> config.sh, Windows (Git Bash) -> config.ps1.

set -euo pipefail

readonly REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

die() { echo "${0##*/}: error: $*" >&2; exit 1; }

case "$(uname -s)" in
  Darwin)
    if ! command -v zsh >/dev/null 2>&1; then
      echo "==> Installing zsh"
      command -v brew >/dev/null 2>&1 || die "Homebrew not found; install zsh manually or install Homebrew first: https://brew.sh"
      brew install zsh
    fi
    exec "$REPO/config.sh"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    command -v powershell.exe >/dev/null 2>&1 || die "powershell.exe not found on PATH"
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$REPO/config.ps1"
    ;;
  *)
    die "unsupported OS: $(uname -s)"
    ;;
esac
