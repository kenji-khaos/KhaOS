#!/bin/bash

# --- 0. Dynamic Path Detection ---
# This finds the exact folder where this script is currently sitting
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BRANDING_DIR="$SCRIPT_DIR/branding"

echo "KhaOS detected at: $SCRIPT_DIR"

# Check if branding folder exists before continuing
if [ ! -d "$BRANDING_DIR" ]; then
    echo "Error: Could not find the 'branding' folder in $SCRIPT_DIR"
    exit 1
fi

# --- 1. System Identity ---
echo "Applying KhaOS identity to system files..."
sudo sed -i 's/^NAME=.*/NAME="KhaOS"/' /etc/os-release
sudo sed -i 's/^PRETTY_NAME=.*/PRETTY_NAME="KhaOS Linux"/' /etc/os-release
sudo sed -i 's/^ID=.*/ID=khaos/' /etc/os-release

# --- 2. Menu Branding & Icons ---
echo "Rebranding tools and applying custom icons..."
mkdir -p ~/.local/share/applications

# Deploy icons to system paths using the dynamic path
sudo mkdir -p /usr/share/icons/hicolor/scalable/apps/
sudo cp "$BRANDING_DIR/KhaOS-starticon.png" /usr/share/icons/hicolor/scalable/apps/khaos-start.png
sudo cp "$BRANDING_DIR/KhaOS-logo.png" /usr/share/pixmaps/khaos-logo.png
sudo cp "$BRANDING_DIR/KhaOS-starticon.png" /usr/share/pixmaps/khaos-start.png

# Improved App Rebranding
APPS=( "hello" "kernel-manager" "packageinstaller" )
for app in "${APPS[@]}"; do
    MATCH=$(ls /usr/share/applications/cachyos-$app*.desktop 2>/dev/null | head -n 1)
    if [ -n "$MATCH" ]; then
        FILE=$(basename "$MATCH")
        cp "$MATCH" ~/.local/share/applications/
        sed -i "s|^Name=.*|Name=KhaOS ${app^}|" ~/.local/share/applications/"$FILE"
        sed -i "s|^Icon=.*|Icon=khaos-start|" ~/.local/share/applications/"$FILE"
    fi
done

update-desktop-database ~/.local/share/applications

# --- 3. Terminal Branding & Fastfetch ---
echo "Customizing terminal and Fastfetch..."
[ -f ~/.config/fish/config.fish ] && sed -i 's/CachyOS/KhaOS/g' ~/.config/fish/config.fish
[ -f ~/.zshrc ] && sed -i 's/CachyOS/KhaOS/g' ~/.zshrc

mkdir -p ~/.config/fastfetch

# Updated: Use Symbolic Links so you only have one version of the file to edit
ln -sf "$BRANDING_DIR/khaos-fastfetch.jsonc" ~/.config/fastfetch/config.jsonc
# Note: We don't need to copy k-os-logo.txt because your jsonc uses 'find' to find it!

# --- 4. Bootloader Branding (Limine) ---
echo "Searching for Limine configuration files..."
CONFIG_FILES=$(sudo find /boot -type f \( -name "limine.conf" -o -name "limine.cfg" \))

if [ -n "$CONFIG_FILES" ]; then
    echo "Found Limine config(s): $CONFIG_FILES"
    echo "$CONFIG_FILES" | xargs -I {} sudo sed -i 's/CachyOS/KhaOS/g' {}
    echo "Limine boot menu updated."
fi

# --- 5. Dynamic Hardware & Greetings ---
echo "[Desktop Entry]
Type=Application
Exec=notify-send 'KhaOS' 'Welcome to your KhaOS environment.' --icon=khaos-start
Name=KhaOS Greeting" > ~/.config/autostart/khaos-greeting.desktop

echo "---------------------------------------------------"
echo "Success! KhaOS is fully deployed from $SCRIPT_DIR."
echo "Reboot to see everything in action."
