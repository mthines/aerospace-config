#!/bin/bash
# Auto-tall layout: when 3+ windows on a workspace, join new window into right stack
sleep 0.2  # let AeroSpace finish placing the window

workspace=$(aerospace list-workspaces --focused)
window_count=$(aerospace list-windows --workspace "$workspace" | wc -l)

if [ "$window_count" -gt 2 ]; then
    aerospace join-with left
fi
