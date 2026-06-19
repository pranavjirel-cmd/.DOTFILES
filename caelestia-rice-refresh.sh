#!/bin/bash
# caelestia-rice-refresh.sh — rebuild the snapshots the rice swapper copies from.
#
# Snapshots are FROZEN copies of each variant's installed files. They go stale
# whenever you:
#   * update/rebuild the official caelestia-shell package, or
#   * update the fork  (git pull in ~/.config/quickshell/caelestia).
# Until you re-run this, switching to that variant restores the OLD files.
#
# No sudo required: official is extracted from the cached AUR package, and the
# fork is staged from its own build tree via DESTDIR.
set -euo pipefail

CACHE="$HOME/.local/share/caelestia-rice"
FORK_SRC="$HOME/.config/quickshell/caelestia"

# --- official: from the newest cached AUR package (no reinstall) ---
PKG=$(ls -1t "$HOME"/.cache/yay/caelestia-shell/caelestia-shell-*.pkg.tar.zst 2>/dev/null | head -1 || true)
if [ -z "${PKG:-}" ]; then
    echo "!! no cached caelestia-shell package in ~/.cache/yay/caelestia-shell/" >&2
    echo "   fetch one without installing:  yay -G caelestia-shell && (cd caelestia-shell && makepkg -f)" >&2
    echo "   then move the *.pkg.tar.zst into ~/.cache/yay/caelestia-shell/ and re-run this." >&2
    exit 1
fi
echo "[official] <- $(basename "$PKG")"
rm -rf "$CACHE/official"; mkdir -p "$CACHE/official"
bsdtar -xpf "$PKG" -C "$CACHE/official" \
    etc/xdg/quickshell/caelestia usr/lib/qt6/qml/Caelestia usr/lib/qt6/qml/M3Shapes usr/lib/caelestia
basename "$PKG" > "$CACHE/official/.snapshot-source"

# --- fork: rebuilt from source and staged via DESTDIR (live-independent) ---
echo "[fork] building + staging from $FORK_SRC"
[ -d "$FORK_SRC/build" ] || cmake -B "$FORK_SRC/build" -S "$FORK_SRC" \
    -G Ninja -DCMAKE_INSTALL_PREFIX=/ -DCMAKE_BUILD_TYPE=RelWithDebInfo
cmake --build "$FORK_SRC/build"
rm -rf "$CACHE/fork"; mkdir -p "$CACHE/fork"
# cmake tries to (re)write $FORK_SRC/build/install_manifest.txt; if that file is
# root-owned from a previous `sudo ./install.sh` you'll see a non-fatal
# "Permission denied" line — the DESTDIR staging still completes and exits 0.
DESTDIR="$CACHE/fork" cmake --install "$FORK_SRC/build"
git -C "$FORK_SRC" rev-parse HEAD > "$CACHE/fork/.snapshot-source" 2>/dev/null || true

echo
echo "refreshed. fingerprints (official /etc should be smaller than fork /etc):"
printf "  official /etc files: %s   (%s)\n" \
    "$(find "$CACHE/official/etc" -type f | wc -l)" "$(cat "$CACHE/official/.snapshot-source")"
printf "  fork     /etc files: %s   (%s)\n" \
    "$(find "$CACHE/fork/etc" -type f | wc -l)" "$(cat "$CACHE/fork/.snapshot-source")"
echo "re-run the matching restore script to apply the refreshed snapshot to the live system."
