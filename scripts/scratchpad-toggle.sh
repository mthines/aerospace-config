#!/bin/bash
# Toggle scratchpad workspace visibility
# If on scratchpad → go back to previous workspace
# If not on scratchpad → go to scratchpad

CURRENT=$(aerospace list-workspaces --focused)

if [ "$CURRENT" = "S" ]; then
    aerospace workspace-back-and-forth
else
    aerospace workspace S
fi
