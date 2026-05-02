#!/bin/bash
# Swap all windows and layout between the current workspace and the target workspace
# Usage: swap-workspace.sh <target-workspace>

TARGET="$1"
CURRENT=$(aerospace list-workspaces --focused)

if [ "$CURRENT" = "$TARGET" ]; then
    exit 0
fi

# Get window IDs in each workspace
CURRENT_WINDOWS=$(aerospace list-windows --workspace "$CURRENT" --format '%{window-id}')
TARGET_WINDOWS=$(aerospace list-windows --workspace "$TARGET" --format '%{window-id}')

# Get root container layout for each workspace
CURRENT_LAYOUT=$(aerospace list-windows --workspace "$CURRENT" --format '%{workspace-root-container-layout}' | head -1)
TARGET_LAYOUT=$(aerospace list-windows --workspace "$TARGET" --format '%{workspace-root-container-layout}' | head -1)

# Move current workspace windows to target
for wid in $CURRENT_WINDOWS; do
    aerospace move-node-to-workspace --window-id "$wid" "$TARGET"
done

# Move target workspace windows to current
for wid in $TARGET_WINDOWS; do
    aerospace move-node-to-workspace --window-id "$wid" "$CURRENT"
done

# Apply swapped layouts
if [ -n "$TARGET_WINDOWS" ] && [ -n "$CURRENT_LAYOUT" ]; then
    aerospace workspace "$CURRENT"
    for wid in $TARGET_WINDOWS; do
        aerospace layout --window-id "$wid" "$CURRENT_LAYOUT" 2>/dev/null
        break  # setting one window's layout sets the container
    done
fi

if [ -n "$CURRENT_WINDOWS" ] && [ -n "$TARGET_LAYOUT" ]; then
    aerospace workspace "$TARGET"
    for wid in $CURRENT_WINDOWS; do
        aerospace layout --window-id "$wid" "$TARGET_LAYOUT" 2>/dev/null
        break
    done
fi

# Follow to the target workspace
aerospace workspace "$TARGET"
