#!/bin/bash
# Toggle window between scratchpad and its previous workspace
# Stores origin workspace per window ID in /tmp so we can return without flipping

SCRATCH_DIR="/tmp/aerospace-scratchpad"
mkdir -p "$SCRATCH_DIR"

CURRENT_WS=$(aerospace list-workspaces --focused)
WID=$(aerospace list-windows --focused --format '%{window-id}')

if [ "$CURRENT_WS" = "S" ]; then
    # On scratchpad — read stored origin and move window back
    ORIGIN_FILE="$SCRATCH_DIR/$WID"
    if [ -f "$ORIGIN_FILE" ]; then
        ORIGIN=$(cat "$ORIGIN_FILE")
        rm "$ORIGIN_FILE"
    else
        ORIGIN="1"  # fallback
    fi
    aerospace move-node-to-workspace --window-id "$WID" "$ORIGIN"
    aerospace workspace "$ORIGIN"
else
    # On regular workspace — store origin, send to scratchpad
    echo "$CURRENT_WS" > "$SCRATCH_DIR/$WID"
    aerospace move-node-to-workspace --window-id "$WID" S
    aerospace workspace S
    aerospace layout --window-id "$WID" tiling
fi
