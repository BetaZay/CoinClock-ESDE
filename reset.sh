#!/usr/bin/env bash
set -euo pipefail

echo "=== CabinetOS Reset Utility ==="

if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (sudo ./reset.sh)"
  exit 1
fi

USER_NAME="cabinet"

echo "[1/4] Stopping services..."
systemctl stop getty@tty1.service || true

echo "[2/4] Removing configs..."
rm -f "/etc/sudoers.d/99-${USER_NAME}"
rm -rf /etc/systemd/system/getty@tty1.service.d
systemctl daemon-reload

if id "$USER_NAME" &>/dev/null; then
  echo "[3/4] Removing user '$USER_NAME'..."
  pkill -u "$USER_NAME" || true
  userdel -r "$USER_NAME" || true
fi

echo "[4/4] Cleaning up..."
rm -rf "/home/${USER_NAME}"
rm -f /root/.bash_profile

systemctl set-default multi-user.target
systemctl enable getty@tty1.service

echo "=== Reset complete. System reverted to base state (root-only). ==="
