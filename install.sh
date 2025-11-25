#!/usr/bin/env bash
set -euo pipefail

echo "=== CabinetOS Installer ==="

# Require root
if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (sudo ./install.sh)"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_NAME="cabinet"

# --- Step 0: Ensure user exists early ---
if ! id "$USER_NAME" &>/dev/null; then
  echo "Creating user '$USER_NAME'..."
  useradd -m -G wheel -s /bin/bash "$USER_NAME"
  passwd "$USER_NAME"
  echo "$USER_NAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99-$USER_NAME
  chmod 440 /etc/sudoers.d/99-$USER_NAME
  echo "User created and added to sudoers."
fi

# --- Step 1: Install packages (via yaycd / under cabinet) ---
sudo -u "$USER_NAME" bash "${SCRIPT_DIR}/scripts/packages.sh"

# --- Step 2: System configuration (autologin etc.) ---
sudo bash "${SCRIPT_DIR}/scripts/config.sh"

# --- Step 3: Install CoinClock application ---
sudo bash "${SCRIPT_DIR}/scripts/install-coin-clock.sh"

echo "=== CabinetOS installation complete ==="
echo "Reboot to start the system."
