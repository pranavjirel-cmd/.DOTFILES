#!/bin/bash
echo "backing up ambxst rice..."

mkdir -p ~/dotfiles/ambxst
rm -rf ~/dotfiles/ambxst/ambxst
cp -r ~/.config/ambxst ~/dotfiles/ambxst/
cp ~/.local/share/ambxst/hyprland.conf ~/dotfiles/ambxst/
cp ~/.local/share/ambxst/hyprland.lua ~/dotfiles/ambxst/
cp ~/.config/hypr/hyprland.conf ~/dotfiles/ambxst/hyprland-main.conf
cp ~/.config/scripts/random-wallpaper-ambxst.sh ~/dotfiles/ambxst/
cp ~/.config/scripts/record-toggle.sh ~/dotfiles/ambxst/

cd ~/dotfiles
git add .
git commit -m "ambxst backup - $(date '+%Y-%m-%d %H:%M')"
git push

echo "done! ambxst backed up to github"
