#!/bin/bash
# Smart focus: uses dfs-next/prev in accordion layouts, regular focus up/down otherwise.
# Usage: smart-focus.sh <next|prev> <up|down>
#
# Was previously calling `aerospace list-windows --format '%{layout}'` which is not a
# valid format key (valid keys: window-layout, window-parent-container-layout, etc.).
# The list-windows call silently errored and `layout` was empty, so the script always
# fell to the else branch — i.e. up/down acted like plain `focus up/down`. That's
# fine for tiles but in an accordion container the user expects dfs-cycle, not
# spatial focus. Fixed to use window-parent-container-layout.

DFS_DIR="$1"    # dfs-next or dfs-prev
FALLBACK="$2"   # up or down

parent_layout=$(aerospace list-windows --focused --format '%{window-parent-container-layout}' 2>/dev/null)

if [ "$parent_layout" = "h_accordion" ] || [ "$parent_layout" = "v_accordion" ]; then
    aerospace focus "$DFS_DIR" --boundaries workspace --boundaries-action wrap-around-the-workspace
else
    aerospace focus "$FALLBACK"
fi
