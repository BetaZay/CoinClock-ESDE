#!/usr/bin/env bash
set -euo pipefail

echo "[2/3] Configuring CabinetOS environment..."

USER_NAME="cabinet"

# Sanity check
if ! id "$USER_NAME" &>/dev/null; then
  echo "Error: user '$USER_NAME' does not exist. Run install.sh again."
  exit 1
fi

# --- Autologin to tty1 ---
mkdir -p /etc/systemd/system/getty@tty1.service.d
cat >/etc/systemd/system/getty@tty1.service.d/autologin.conf <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $USER_NAME --noclear %I \$TERM
EOF

# --- Auto-launch EmulationStation on login ---
mkdir -p /home/$USER_NAME
cat >/home/$USER_NAME/.bash_profile <<'EOF'
# CabinetOS auto-launch·
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
  clear
  /opt/CoinClock/CoinClock
fi
chown "$USER_NAME:$USER_NAME" /home/$USER_NAME/.bash_profile

# --- Enable core services ---
systemctl set-default multi-user.target

# --- Create rom dirs ---
SRC_DIR="/opt/CabinetOS/es-de"
DEST_DIR="/home/cabinet/ROMs"

echo "[2/3] Setting up ROM directories..."

# Create destination if missing
mkdir -p "$SRC_DIR"
mkdir -p "$DEST_DIR"

# Copy contents recursively, preserving permissions
cp -rT "$SRC_DIR" "$DEST_DIR"

# Fix ownership so the cabinet user owns it
chown -R cabinet:cabinet "$DEST_DIR"

echo "ROM directories copied from $SRC_DIR to $DEST_DIR."

# --- Enable services ---
sudo systemctl enable --now sshd

echo "SSH Enabled. IP address information:"
ip addr show
echo ""

echo "[2/3] Configuration complete. System will autologin as '$USER_NAME' and start EmulationStation on tty1."
