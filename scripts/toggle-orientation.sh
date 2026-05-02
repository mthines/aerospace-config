#!/bin/bash
# Pair-merge: focused window joins its (1,2),(3,4),(5,6)... partner into a perpendicular split.
# When already nested, flatten back to root.

LOG=/tmp/aerospace-toggle.log
echo "--- $(date) ---" >> "$LOG"

parent=$(aerospace list-windows --focused --format '%{window-parent-container-layout}')
root=$(aerospace list-windows --focused --format '%{workspace-root-container-layout}')
focused_id=$(aerospace list-windows --focused --format '%{window-id}')
workspace=$(aerospace list-workspaces --focused)

echo "parent=$parent root=$root focused_id=$focused_id workspace=$workspace" >> "$LOG"

if [ "$parent" != "$root" ]; then
    echo "nested → flatten" >> "$LOG"
    aerospace flatten-workspace-tree 2>>"$LOG"
    exit 0
fi

# 1-based index of focused window in workspace's flat list (DFS order = visual order at root)
index=$(aerospace list-windows --workspace "$workspace" --format '%{window-id}' | grep -n "^$focused_id$" | cut -d: -f1)
echo "index=$index" >> "$LOG"

case "$parent" in
    h_tiles|h_accordion)
        if (( index % 2 == 1 )); then
            # odd (1st, 3rd, ...) → partner is to the right
            aerospace join-with right 2>>"$LOG" || aerospace join-with left 2>>"$LOG"
        else
            # even (2nd, 4th, ...) → partner is to the left
            aerospace join-with left 2>>"$LOG" || aerospace join-with right 2>>"$LOG"
        fi
        aerospace layout v_tiles 2>>"$LOG"
        ;;
    v_tiles|v_accordion)
        if (( index % 2 == 1 )); then
            aerospace join-with down 2>>"$LOG" || aerospace join-with up 2>>"$LOG"
        else
            aerospace join-with up 2>>"$LOG" || aerospace join-with down 2>>"$LOG"
        fi
        aerospace layout h_tiles 2>>"$LOG"
        ;;
esac
echo "done" >> "$LOG"
