#!/bin/bash
echo "backing up caelestia-fork rice..."

mkdir -p ~/dotfiles/caelestia-fork
rm -rf ~/dotfiles/caelestia-fork/config
cp -r ~/.config/caelestia ~/dotfiles/caelestia-fork/config
cp ~/.zshrc ~/dotfiles/caelestia-fork/.zshrc 2>/dev/null

# fork provenance — remote + commit, so the fork snapshot can always be rebuilt
# from source (the binary snapshot itself is NOT committed; it is large and
# reproducible via caelestia-rice-refresh.sh).
{
  git -C ~/.config/quickshell/caelestia remote get-url origin 2>/dev/null
  git -C ~/.config/quickshell/caelestia rev-parse HEAD 2>/dev/null
} > ~/dotfiles/caelestia-fork/fork-source.txt

caelestia scheme get --name > ~/dotfiles/caelestia-fork/scheme.txt 2>/dev/null

cd ~/dotfiles
git add -A
git commit -m "caelestia-fork backup - $(date '+%Y-%m-%d %H:%M')"
git push

echo "done! caelestia-fork backed up to github"
