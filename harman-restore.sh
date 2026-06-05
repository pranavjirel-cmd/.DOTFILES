#!/bin/bash
echo "restoring harman rice..."

pkill swww-daemon
pkill awww-daemon
sleep 1
awww-daemon &
sleep 1
pkill -f "src/ambxst"
pkill quickshell
pkill axctl
sleep 2

cp ~/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf.bak
cp -r ~/dotfiles/harman/hypr ~/.config/
cp -r ~/dotfiles/harman/quickshell ~/.config/
cp -r ~/dotfiles/harman/swaync ~/.config/
sed -i '/source = ~\/.local\/share\/ambxst\/hyprland.conf/d' ~/.config/hypr/hyprland.conf
sed -i '107,189s/^#bind/bind/; 107,189s/^#binde/binde/; 107,189s/^#bindm/bindm/' ~/.config/hypr/hyprland.conf
hyprctl reload
wal -R
swww img $(cat ~/.cache/wal/wal) --transition-type wipe --transition-duration 1
sleep 1
quickshell &

echo "done! harman restored"
