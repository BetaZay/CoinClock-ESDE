#!/usr/bin/env bash
set -euo pipefail

echo "[0/3] Installing yay (AUR helper)..."

# Skip if already installed
if command -v yay >/dev/null 2>&1; then
  echo "yay already installed, skipping."
  exit 0
fi

# Ensure core build tools
sudo pacman -Syu --noconfirm --needed base-devel git

# Build yay in a temp directory
TMPDIR=$(mktemp -d)
cd "$TMPDIR"

git clone https://aur.archlinux.org/yay.git
cd yay

# Non-interactive AUR build
makepkg --syncdeps --noconfirm --clean --cleanbuild

# Install the resulting package
sudo pacman -U --noconfirm ./*.pkg.tar.*

# Cleanup
cd /
rm -rf "$TMPDIR"

echo "yay installed successfully."
