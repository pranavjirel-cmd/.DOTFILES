#!/bin/bash
echo "restoring ambxst rice..."

pkill swww-daemon
pkill awww-daemon
sleep 1
awww-daemon &
sleep 1
pkill quickshell
pkill swaync
pkill -f "src/ambxst"
pkill axctl
sleep 2

cp -r ~/dotfiles/ambxst/ambxst ~/.config/
cp ~/dotfiles/ambxst/hyprland.conf ~/.local/share/ambxst/
cp ~/dotfiles/ambxst/hyprland.lua ~/.local/share/ambxst/
cp ~/dotfiles/ambxst/hyprland-main.conf ~/.config/hypr/hyprland.conf
sed -i '/source = ~\/.local\/share\/ambxst\/hyprland.conf/d' ~/.config/hypr/hyprland.conf
echo "source = ~/.local/share/ambxst/hyprland.conf" >> ~/.config/hypr/hyprland.conf
hyprctl reload
sleep 2
ambxst & disown
~/.config/scripts/wal-watcher.sh &

echo "done! ambxst restored"
