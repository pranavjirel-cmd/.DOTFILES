#!/bin/bash
echo "restoring caelestia rice..."

pkill -x qs 2>/dev/null
pkill -x quickshell 2>/dev/null
pkill -x swaync 2>/dev/null
pkill -x mako 2>/dev/null
pkill -x awww-daemon 2>/dev/null

mkdir -p ~/.config/hypr
cat ~/.local/share/caelestia/hypr/hyprland.conf > ~/.config/hypr/hyprland.conf
cd ~/.config/hypr
find . -maxdepth 1 ! -name hyprland.conf ! -name . -exec rm -rf {} +
ln -sf ~/.local/share/caelestia/hypr/hyprland hyprland
ln -sf ~/.local/share/caelestia/hypr/scripts scripts
ln -sf ~/.local/share/caelestia/hypr/variables.conf variables.conf
ln -sf ~/.local/share/caelestia/hypr/scheme scheme
cp -n ~/.local/share/caelestia/hypr/scheme/default.conf ~/.local/share/caelestia/hypr/scheme/current.conf 2>/dev/null

cp -r ~/dotfiles/caelestia/config/* ~/.config/caelestia/ 2>/dev/null

hyprctl reload
caelestia shell -d
sleep 1
caelestia scheme set --name dynamic 2>/dev/null

echo "done! caelestia restored"
