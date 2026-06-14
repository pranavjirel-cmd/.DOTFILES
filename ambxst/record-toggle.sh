#!/bin/bash
OUTPUT_DIR="$HOME/Videos/Recordings"
mkdir -p "$OUTPUT_DIR"

if pgrep -f gpu-screen-recorder > /dev/null; then
    pkill -SIGINT -f gpu-screen-recorder
    sleep 1
    VIDEO=$(ls -t "$OUTPUT_DIR"/*.mp4 2>/dev/null | head -n1)
    if [ -f "$VIDEO" ]; then
        wl-copy --type text/uri-list "file://$VIDEO"
        notify-send "Recording stopped" "Saved & copied to clipboard"
    fi
else
    VIDEO="$OUTPUT_DIR/rec_$(date +%Y%m%d_%H%M%S).mp4"
    gpu-screen-recorder -w eDP-1 -f 60 -a default_output -o "$VIDEO" &
    notify-send "Recording started"
fi
