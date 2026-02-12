#!/bin/bash

# --- 1. System Identity ---
echo "Applying KhaOS identity to system files..."
sudo sed -i 's/^NAME=.*/NAME="KhaOS"/' /etc/os-release
sudo sed -i 's/^PRETTY_NAME=.*/PRETTY_NAME="KhaOS Linux"/' /etc/os-release
sudo sed -i 's/^ID=.*/ID=khaos/' /etc/os-release

# --- 2. Menu Branding & Icons ---
echo "Rebranding tools and applying custom icons..."
mkdir -p ~/.local/share/applications
BRANDING_DIR="./branding"

# Deploy icons to system paths so KDE can find them
sudo mkdir -p /usr/share/icons/hicolor/scalable/apps/
sudo cp "$BRANDING_DIR/KhaOS-starticon.png" /usr/share/icons/hicolor/scalable/apps/khaos-start.png
sudo cp "$BRANDING_DIR/KhaOS-logo.png" /usr/share/pixmaps/khaos-logo.png
sudo cp "$BRANDING_DIR/KhaOS-starticon.png" /usr/share/pixmaps/khaos-start.png

# Improved App Rebranding (Finds them even if names vary)
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

# --- 3. Terminal Branding (Fish, Zsh, Fastfetch) ---
echo "Customizing terminal and Fastfetch..."
[ -f ~/.config/fish/config.fish ] && sed -i 's/CachyOS/KhaOS/g' ~/.config/fish/config.fish
[ -f ~/.zshrc ] && sed -i 's/CachyOS/KhaOS/g' ~/.zshrc

mkdir -p ~/.config/fastfetch
cp "$BRANDING_DIR/khaos-fastfetch.jsonc" ~/.config/fastfetch/config.jsonc
cp "$BRANDING_DIR/k-os-logo.txt" ~/.config/fastfetch/k-os-logo.txt

# --- 4. Bootloader Branding (Limine) ---
echo "Searching for Limine configuration files..."
# This finds either limine.cfg OR limine.conf anywhere in /boot
CONFIG_FILES=$(sudo find /boot -type f \( -name "limine.conf" -o -name "limine.cfg" \))

if [ -n "$CONFIG_FILES" ]; then
    echo "Found Limine config(s): $CONFIG_FILES"
    echo "$CONFIG_FILES" | xargs -I {} sudo sed -i 's/CachyOS/KhaOS/g' {}
    echo "Limine boot menu updated."
fi

# --- 5. Dynamic Hardware & Greetings ---
echo "Verifying hardware and adding greetings..."
CPU_MODEL=$(lscpu | grep "Model name:" | cut -d':' -f2 | sed 's/^[ \t]*//')
echo "Confirmed hardware: $CPU_MODEL"

# Disable original welcome screen and add KhaOS notification
if [ -f /etc/xdg/autostart/cachyos-hello.desktop ]; then
    sudo sed -i 's/NoDisplay=false/NoDisplay=true/' /etc/xdg/autostart/cachyos-hello.desktop
fi

mkdir -p ~/.config/autostart
echo "[Desktop Entry]
Type=Application
Exec=notify-send 'KhaOS' 'Welcome to your KhaOS environment.' --icon=khaos-start
Name=KhaOS Greeting" > ~/.config/autostart/khaos-greeting.desktop

echo "---------------------------------------------------"
echo "Success! KhaOS is fully deployed. Reboot to see everything in action."