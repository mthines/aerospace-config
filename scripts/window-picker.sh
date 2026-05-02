#!/usr/bin/env bash
# Mission Control–style window picker for AeroSpace.
# Lists every window across all workspaces in fzf; on select, focuses it.

set -euo pipefail

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

FORMAT='%{workspace}  │  %{app-name}  │  %{window-title}#%{window-id}'

selection=$(
  aerospace list-windows --all --format "$FORMAT" \
    | fzf \
        --delimiter='#' \
        --with-nth=1 \
        --prompt='󱂬  window › ' \
        --header='Enter: focus  •  Esc: cancel' \
        --height=100% \
        --layout=reverse \
        --border=rounded \
        --info=inline \
        --color='border:#7aa2f7,prompt:#bb9af7,header:#9ece6a' \
    || true
)

[[ -z "$selection" ]] && exit 0

window_id="${selection##*#}"
aerospace focus --window-id "$window_id"
