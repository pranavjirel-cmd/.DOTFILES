# Caelestia rice swap (official ⇄ fork)

The official AUR `caelestia-shell` and the [dim-ghub fork] both use the same quickshell
config name (`caelestia`), the same `Caelestia` QML plugin path, and the same CLI socket,
so **only one can be installed at a time**. The rice switcher swaps between them by copying
a pre-built **snapshot** of each variant's installed files into the system paths — no
rebuild at switch time.

[dim-ghub fork]: https://github.com/dim-ghub/caelestia-shell

## Pieces

| Path | What |
|------|------|
| `~/.local/share/caelestia-rice/{official,fork}/` | The two snapshots (frozen copies of the installed files). Not in git — large + reproducible. |
| `caelestia-rice/caelestia-rice-swap` | Root helper → installed to `/usr/local/bin/`. `rsync -a --delete`s a snapshot into the 4 system paths. |
| `caelestia-rice/caelestia-rice.sudoers` | NOPASSWD rule → installed to `/etc/sudoers.d/caelestia-rice`. Exact-match, no wildcards. |
| `caelestia-restore.sh` / `caelestia-fork-restore.sh` | Per-rice restore: kill shell → `sudo caelestia-rice-swap <variant>` → hypr setup → `caelestia shell -d`. |
| `caelestia-fork-backup.sh` | Backs up the shared config + fork provenance (remote+SHA) to git. |
| `caelestia-rice-refresh.sh` | Rebuilds both snapshots. **Run after any update/rebuild (see below).** |

The four swapped paths: `/etc/xdg/quickshell/caelestia`, `/usr/lib/qt6/qml/Caelestia`,
`/usr/lib/qt6/qml/M3Shapes`, `/usr/lib/caelestia`. (`/usr/bin/caelestia` is the separate
`caelestia-cli` package and is **not** touched.) `~/.config/caelestia` is the shared user
config and is **never** deleted by the restore scripts.

## One-time install (needs sudo)

```bash
sudo install -m755 ~/dotfiles/caelestia-rice/caelestia-rice-swap /usr/local/bin/caelestia-rice-swap
sudo visudo -cf ~/dotfiles/caelestia-rice/caelestia-rice.sudoers && \
  sudo install -m440 -o root -g root ~/dotfiles/caelestia-rice/caelestia-rice.sudoers /etc/sudoers.d/caelestia-rice
```

After that, switching is one keypress via `rice-switcher.sh` (entries **Caelestia** and
**Caelestia-Fork**), or directly:

```bash
bash ~/dotfiles/caelestia-restore.sh        # official
bash ~/dotfiles/caelestia-fork-restore.sh   # fork
```

## ⚠️ Snapshots go STALE

The snapshots are frozen at the moment they were taken. They do **not** track updates.
After **either** of these, the matching snapshot is out of date and the switcher would
restore the OLD files until you refresh:

* you update/rebuild the official `caelestia-shell` (a newer `*.pkg.tar.zst` lands in
  `~/.cache/yay/caelestia-shell/`), **or**
* you `git pull` / rebuild the fork in `~/.config/quickshell/caelestia`.

Refresh both snapshots (no sudo):

```bash
bash ~/dotfiles/caelestia-rice-refresh.sh
```

Then re-run the matching restore script to apply the refreshed snapshot to the live system.
The official snapshot is taken from the newest cached AUR package; the fork snapshot is
rebuilt from source via `DESTDIR` (so it doesn't matter which variant is currently live).

## Verify a swap took effect

`/etc` file count is a quick fingerprint — **official ≈ 286**, **fork ≈ 456**:

```bash
find /etc/xdg/quickshell/caelestia -type f | wc -l
```

## Security note

The NOPASSWD helper reads snapshots from user-writable `~/.local/share`, so anything that
can write there as you could have root copy it into `/etc` + `/usr/lib`. Accepted as a
single-user-box trade-off for one-keypress switching. The command surface is otherwise
tight: a fixed root-owned script + exact-match sudoers. To harden, move the snapshots to a
root-owned dir (e.g. `/var/cache/caelestia-rice`) and update `CACHE=` in the helper +
refresh script — at the cost of needing sudo to refresh.
