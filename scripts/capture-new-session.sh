#!/bin/bash
# local patch: Super+Alt+Shift+N. Select a region, and the Keepalive panel
# opens on the New session field with that screenshot attached. Esc during
# the selection opens the field without one.
set -uo pipefail

dir=${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/sessions/attachments
mkdir -p "$dir"
file=$dir/$(date +%Y%m%d-%H%M%S)-$RANDOM.png
if geometry=$(slurp 2>/dev/null) && grim -g "$geometry" "$file" 2>/dev/null; then
  omarchy-shell io.github.mphaxise.keepalive newSessionWith "$file"
else
  rm -f "$file"
  omarchy-shell io.github.mphaxise.keepalive newSession
fi
