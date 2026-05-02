#!/bin/bash
# Move the focused window one position clockwise in the layout.
# If it can't move right (at the edge), wrap to the far left by
# repeatedly moving left until it can't go further.

if aerospace move --boundaries workspace --boundaries-action fail right 2>/dev/null; then
    exit 0
fi

# At the right edge — wrap around to the leftmost position
while aerospace move --boundaries workspace --boundaries-action fail left 2>/dev/null; do
    :
done
