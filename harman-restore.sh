#!/bin/bash
echo "restoring harman rice..."

pkill -f ambxst
pkill quickshell
sleep 1


cp -r ~/dotfiles/harman/hypr ~/.config/
cp -r ~/dotfiles/harman/quickshell ~/.config/
cp -r ~/dotfiles/harman/swaync ~/.config/
hyprctl reload
wal -R
quickshell &

echo "done! harman restored"

