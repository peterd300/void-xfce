#!/usr/bin/env bash

sudo xbps-install -Sy wget unzip fontconfig fc-cache


set -Eeuo pipefail

font="HackNerd"
tempdir="$HOME/temp"
fontdir="$HOME/.local/share/fonts/$font"
log_file="$HOME/${font}.log"
zipfile="$tempdir/Hack.zip"
extractdir="$tempdir/Hack"

exec > >(tee -a "$log_file") 2>&1

mkdir -p "$tempdir"
mkdir -p "$fontdir"

echo "Downloading Hack Nerd Font to: $zipfile"

wget \
    --progress=bar:force \
    -O "$zipfile" \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"

rm -rf "$extractdir"
mkdir -p "$extractdir"

echo "Extracting fonts..."
unzip -q "$zipfile" -d "$extractdir"

echo "Installing fonts..."
find "$extractdir" -type f \( -iname "*.ttf" -o -iname "*.otf" \) \
    -exec install -m 644 {} "$fontdir/" \;

echo "Refreshing font cache..."
fc-cache -f

echo "Installed fonts:"
fc-list | grep -i "Hack" || true

echo "Installation complete."
echo "Downloaded ZIP: $zipfile"
echo "Log file: $log_file"



