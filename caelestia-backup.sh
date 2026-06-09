#!/bin/bash
echo "backing up caelestia rice..."

mkdir -p ~/dotfiles/caelestia

cp -r ~/.config/caelestia ~/dotfiles/caelestia/config 2>/dev/null
cp ~/.zshrc ~/dotfiles/caelestia/.zshrc 2>/dev/null
caelestia scheme get --name > ~/dotfiles/caelestia/scheme.txt 2>/dev/null

cd ~/dotfiles
git add .
git commit -m "caelestia backup - $(date '+%Y-%m-%d %H:%M')"
git push

echo "done! caelestia backed up to github"
