#!/bin/bash
# local patch: Ctrl+V in the New session field. When the clipboard holds an
# image (a screenshot from Omarchy's capture, a copied picture), save it
# under the sessions state folder and print its path; the panel attaches it
# to the first prompt. Exit 1 when the clipboard holds no image, and the
# field pastes text as usual.
set -uo pipefail

type=$(wl-paste --list-types 2>/dev/null | grep -m1 -E '^image/(png|jpeg|webp|gif)$') || exit 1
ext=${type#image/}
[[ $ext == jpeg ]] && ext=jpg

dir=${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/sessions/attachments
mkdir -p "$dir"
file=$dir/$(date +%Y%m%d-%H%M%S)-$RANDOM.$ext
wl-paste --type "$type" >"$file" 2>/dev/null && [[ -s $file ]] || { rm -f "$file"; exit 1; }
echo "$file"
