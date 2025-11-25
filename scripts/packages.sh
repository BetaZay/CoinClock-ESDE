#!/usr/bin/env bash
set -euo pipefail

echo "[1/3] Installing CabinetOS packages..."

# Ensure paru exists
if ! command -v yay >/dev/null 2>&1; then
  bash "$(dirname "$0")/install_yay.sh"
fi

PKGS=(
  base-devel
  openssh
  dbus
  git
  curl
  wget
  unzip
  fastfetch
  alsa-utils
  pulseaudio
  pulseaudio-alsa
  sof-firmware
  xorg-server
  xorg-xinit
  mesa
  libglvnd
  libdrm
  libinput
  sdl2
  sdl2_ttf
  sdl2_mixer
  sdl2_image
  retroarch
  freeimage
  emulationstation-de
  retroarch-core-info
  retroarch-assets
  libretro-nestopia
  libretro-snes9x
  libretro-gambatte
  libretro-pcsx2
  libretro-pcsx_rearmed
  libretro-mgba
  libretro-flycast
  libretro-parallel-n64
  vlc
  libvlc
  ffmpeg
  vlc-plugins-all
  icu76
)

yay -Syu --noconfirm --needed "${PKGS[@]}"

echo "[1/3] Package installation complete."
