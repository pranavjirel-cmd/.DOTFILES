#!/bin/bash
SCHEME="$HOME/.local/state/caelestia/scheme.json"
LAST=""
while true; do
    CUR=$(stat -c %Y "$SCHEME" 2>/dev/null)
    if [ -n "$CUR" ] && [ "$CUR" != "$LAST" ]; then
        python3 - << 'PYEOF'
import json, os
p = os.path.expanduser("~/.local/state/caelestia/scheme.json")
c = json.load(open(p))["colours"]
def h(k): return "#" + c[k]
theme = {
    "special": {"background": h("background"), "foreground": h("onBackground"), "cursor": h("primary")},
    "colors": {f"color{i}": "#" + c[f"term{i}"] for i in range(16)},
}
theme["colors"]["color0"] = h("surfaceContainer")
theme["colors"]["color4"] = h("primary")
theme["colors"]["color5"] = h("tertiary")
theme["colors"]["color6"] = h("secondary")
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
