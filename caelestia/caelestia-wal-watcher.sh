#!/bin/bash
SCHEME="$HOME/.local/state/caelestia/scheme.json"
LAST=""
while true; do
    CUR=$(stat -c %Y "$SCHEME" 2>/dev/null)
    if [ -n "$CUR" ] && [ "$CUR" != "$LAST" ]; then
        python3 - << 'PYEOF'
import json, os
BG_MIX = 0.15      # how much primary hue tints the page background
PANEL_MIX = 0.25   # how much primary hue tints panels
p = os.path.expanduser("~/.local/state/caelestia/scheme.json")
c = json.load(open(p))["colours"]
def mix(a, b, t):
    return "".join(f"{round(int(a[i:i+2],16)*(1-t)+int(b[i:i+2],16)*t):02x}" for i in (0,2,4))
bg = "#" + mix(c["background"], c["primary"], BG_MIX)
panel = "#" + mix(c["background"], c["primary"], PANEL_MIX)
theme = {
    "special": {"background": bg, "foreground": "#"+c["onBackground"], "cursor": "#"+c["primary"]},
    "colors": {f"color{i}": "#" + c[f"term{i}"] for i in range(16)},
}
theme["colors"]["color0"] = panel
theme["colors"]["color4"] = "#"+c["primary"]
theme["colors"]["color5"] = "#"+c["tertiary"]
theme["colors"]["color6"] = "#"+c["secondary"]
json.dump(theme, open(os.path.expanduser("~/.cache/caelestia-wal.json"), "w"))
PYEOF
        wal -n --theme ~/.cache/caelestia-wal.json
        pywal-discord 2>/dev/null &
        cp ~/.cache/wal/youtube.user.css /tmp/yt.tmp 2>/dev/null
        mv /tmp/yt.tmp ~/.cache/wal/yt-stylus.user.css 2>/dev/null
        LAST="$CUR"
    fi
    sleep 2
done
