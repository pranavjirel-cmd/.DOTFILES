#!/bin/bash
echo "restoring ambxst rice..."

pkill quickshell
pkill swaync

cp -r ~/dotfiles/ambxst/ambxst ~/.config/
cp ~/dotfiles/ambxst/hyprland.conf ~/.local/share/ambxst/
cp ~/dotfiles/ambxst/hyprland.lua ~/.local/share/ambxst/
cp ~/dotfiles/ambxst/hyprland-main.conf ~/.config/hypr/hyprland.conf
hyprctl reload
ambxst & disown

echo "done! ambxst restored"
