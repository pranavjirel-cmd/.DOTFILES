#!/bin/bash
echo "restoring harman rice..."

pkill -x qs 2>/dev/null
pkill -x quickshell 2>/dev/null

cp -r ~/dotfiles/harman/hypr ~/.config/
cp -r ~/dotfiles/harman/quickshell ~/.config/
cp -r ~/dotfiles/harman/swaync ~/.config/
hyprctl reload

swww-daemon 2>/dev/null &
quickshell 2>/dev/null &
swaync 2>/dev/null &

sleep 2
WALL=~/wallpapers/Girl-Short-Hair.jpg
quickshell ipc call randomwallpaper apply "$WALL"
wal -i "$WALL" --saturate 1.0

echo "done! harman restored"
