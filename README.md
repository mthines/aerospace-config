# aerospace-config

My personal [AeroSpace](https://github.com/nikitabobko/AeroSpace) window manager config and helper scripts for macOS. Tuned for a Danish ISO keyboard, dual-monitor setup, and an Amethyst-style ergonomics.

## Layout

```
aerospace.toml                       # main AeroSpace config (symlinked to ~/.aerospace.toml)
scripts/                             # helper scripts (symlinked to ~/.config/aerospace/scripts)
  move-clockwise.sh
  rotate-windows.sh
  scratchpad-toggle.sh
  scratchpad-move.sh
  smart-focus.sh
  swap-workspace.sh
  toggle-orientation.sh
  window-picker.sh
local-bin/
  aerospace-tall-layout.sh           # symlinked to ~/.local/bin/aerospace-tall-layout.sh
```

## Install

Clone anywhere you like, then symlink the files into place:

```sh
git clone git@github.com:mthines/aerospace-config.git ~/code/aerospace-config
cd ~/code/aerospace-config

# config
ln -s "$PWD/aerospace.toml" ~/.aerospace.toml

# scripts
mkdir -p ~/.config/aerospace
ln -s "$PWD/scripts" ~/.config/aerospace/scripts

# tall-layout helper (referenced by absolute path in aerospace.toml)
mkdir -p ~/.local/bin
ln -s "$PWD/local-bin/aerospace-tall-layout.sh" ~/.local/bin/aerospace-tall-layout.sh

# reload AeroSpace
aerospace reload-config
```

## Notes

- The `[overview]` block and `alt-tab = 'overview'` binding require the [AeroSpace-Debug fork](https://github.com/nikitabobko/AeroSpace) build that exposes the workspace overview command. Remove both if you're on upstream AeroSpace.
- Workspace assignments and floating-window rules near the bottom of `aerospace.toml` are personal — adjust to taste.
- Modifier conventions: `ctrl-alt` = main, `alt` = focus, `alt-cmd` = resize, `ctrl-alt-shift` = service-mode entry.
