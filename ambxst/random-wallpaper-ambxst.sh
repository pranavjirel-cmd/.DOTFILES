#!/bin/bash
WALL_DIR="$HOME/wallpapers"
selected_path=$(find "$WALL_DIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' -o -iname '*.png' -o -iname '*.webp' \) ! -name ".*" | shuf -n1)

if [ -f "$selected_path" ]; then
    awww img "$selected_path" --transition-type wipe --transition-duration 1
    wal -i "$selected_path" --saturate 1.0
fi
