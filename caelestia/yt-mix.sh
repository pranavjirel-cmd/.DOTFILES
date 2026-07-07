#!/bin/bash
# usage: bash yt-mix.sh <bg_mix> <panel_mix>   e.g. bash yt-mix.sh 0.18 0.28
BG=${1:-0.20}; PANEL=${2:-0.30}
W=~/.config/scripts/caelestia-wal-watcher.sh
sed -i "s/^BG_MIX = .*/BG_MIX = $BG/; s/^PANEL_MIX = .*/PANEL_MIX = $PANEL/" "$W"
pkill -f caelestia-wal-watcher
hyprctl dispatch exec "$W"
sleep 2
touch "$HOME/.local/state/caelestia/scheme.json"
sleep 5
echo "mix now: bg=$BG panel=$PANEL"
grep -m1 yt-bg ~/.cache/wal/yt-stylus.user.css
