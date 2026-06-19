#!/bin/bash
echo "restoring caelestia (fork) rice..."

pkill -x qs 2>/dev/null
pkill -x quickshell 2>/dev/null
pkill -x swaync 2>/dev/null
pkill -x mako 2>/dev/null
pkill -x awww-daemon 2>/dev/null

# swap the Caelestia shell system files to the fork snapshot (NOPASSWD helper)
sudo /usr/local/bin/caelestia-rice-swap fork

mkdir -p ~/.config/hypr
cat ~/.local/share/caelestia/hypr/hyprland.conf > ~/.config/hypr/hyprland.conf
cd ~/.config/hypr
find . -maxdepth 1 ! -name hyprland.conf ! -name . -exec rm -rf {} +
ln -sf ~/.local/share/caelestia/hypr/hyprland hyprland
ln -sf ~/.local/share/caelestia/hypr/scripts scripts
ln -sf ~/.local/share/caelestia/hypr/variables.conf variables.conf
ln -sf ~/.local/share/caelestia/hypr/scheme scheme
cp -n ~/.local/share/caelestia/hypr/scheme/default.conf ~/.local/share/caelestia/hypr/scheme/current.conf 2>/dev/null

# NOTE: ~/.config/caelestia is the SHARED user config — intentionally left untouched.

hyprctl reload
caelestia shell -d
sleep 1
caelestia scheme set --name dynamic 2>/dev/null

echo "done! caelestia (fork) restored"
