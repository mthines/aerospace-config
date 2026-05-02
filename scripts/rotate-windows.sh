#!/bin/bash
# Rotate all windows in the current workspace using swap (preserves layout).
# Uses DFS index to reliably find first/last window regardless of list order.
# Usage: rotate-windows.sh [right|left]
#   right (default): rotate contents to the right — last wraps to first
#   left:            rotate contents to the left  — first wraps to last

direction="${1:-right}"
focused_id=$(aerospace list-windows --focused --format '%{window-id}' 2>/dev/null | head -1)
count=$(aerospace list-windows --workspace focused --format '%{window-id}' 2>/dev/null | wc -l | tr -d ' ')

# Need at least 2 windows to rotate
if [[ $count -lt 2 ]]; then
    exit 0
fi

swaps=$((count - 1))

if [[ "$direction" == "right" ]]; then
    # Focus the DFS-first window by index, then bubble it to the end
    aerospace focus --dfs-index 0
    for ((i = 0; i < swaps; i++)); do
        aerospace swap dfs-next
    done
else
    # Focus the DFS-last window by index, then bubble it to the front
    aerospace focus --dfs-index "$swaps"
    for ((i = 0; i < swaps; i++)); do
        aerospace swap dfs-prev
    done
fi

# Restore focus to the originally focused window
if [[ -n "$focused_id" ]]; then
    aerospace focus --window-id "$focused_id"
fi
