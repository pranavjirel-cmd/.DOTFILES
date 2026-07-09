#!/bin/bash
echo "backing up harman rice..."

cp ~/.config/hypr/hyprland.conf ~/dotfiles/harman/hypr/
cp ~/.config/hypr/harman-keybinds.conf ~/dotfiles/harman/hypr/
cp ~/.config/hypr/hyprlock.conf ~/dotfiles/harman/hypr/
cp -r ~/.config/quickshell ~/dotfiles/harman/
cp -r ~/.config/swaync ~/dotfiles/harman/
cp ~/.zshrc ~/dotfiles/harman/

cd ~/dotfiles
git add .
git commit -m "harman backup - $(date '+%Y-%m-%d %H:%M')"
git push || echo "!! PUSH FAILED — run git pull --rebase && git push"

echo "done! harman backed up to github"
