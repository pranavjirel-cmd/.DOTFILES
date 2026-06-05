#!/bin/bash
echo "restoring ambxst rice..."

pkill quickshell
pkill swaync
pkill -f "src/ambxst/shell.qml"
sleep 1


cp -r ~/dotfiles/ambxst/ambxst ~/.config/
cp ~/dotfiles/ambxst/hyprland.conf ~/.local/share/ambxst/
cp ~/dotfiles/ambxst/hyprland.lua ~/.local/share/ambxst/
cp ~/dotfiles/ambxst/hyprland-main.conf ~/.config/hypr/hyprland.conf
echo "source = ~/.local/share/ambxst/hyprland.conf" >> ~/.config/hypr/hyprland.conf
hyprctl reload
sleep 1
ambxst & disown

echo "done! ambxst restored"
