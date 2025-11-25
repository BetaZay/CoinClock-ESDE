#!/usr/bin/env bash
set -euo pipefail

echo "=== Installing CoinClock Application ==="

# Ensure directories exist
mkdir -p /home/cabinet
mkdir -p /opt/CoinClock

# Clone/update source
if [ ! -d /home/cabinet/CoinClock ]; then
    git clone https://github.com/BetaZay/CoinClock.git /home/cabinet/CoinClock
else
    echo "Repo already exists, pulling latest…"
    git -C /home/cabinet/CoinClock pull --rebase
fi

# Build release
cd /home/cabinet/CoinClock
./build.sh -r

# Install binary and assets
install -m 755 build-release/CoinClock /opt/CoinClock/CoinClock

# Assets need -r, always
rm -rf /opt/CoinClock/assets
cp -r build-release/assets /opt/CoinClock/assets

echo "=== Install Complete ==="
echo "Run with: /opt/CoinClock/CoinClock"
