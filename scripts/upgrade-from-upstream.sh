#!/bin/bash
# local patch: take a new upstream Keepalive with the local commits on top
# (LOCAL-PATCHES.md). `omarchy plugin update` cannot, because it only
# fast-forwards.
#
#   scripts/upgrade-from-upstream.sh [--dry]
#
# Stops at the first problem and says how to back out; nothing is pushed
# until the tests pass and the plugin validates.
set -euo pipefail
cd "$(dirname "$0")/.."

[[ -z $(git status --porcelain --untracked-files=no) ]] || { echo "uncommitted changes; commit them first" >&2; exit 1; }
git fetch --quiet origin
new=$(git log --oneline main..origin/main)
if [[ -z $new ]]; then echo "upstream has nothing new"; exit 0; fi
echo "upstream commits to take:"; echo "$new"
[[ ${1:-} == --dry ]] && exit 0

before=$(git rev-parse HEAD)
git branch -f "backup/before-upgrade" "$before"
if ! git rebase origin/main; then
  echo "rebase stopped on a conflict: resolve, then 'git rebase --continue'" >&2
  echo "or back out: git rebase --abort" >&2
  exit 1
fi
python3 -m unittest discover -s tests -q || { echo "tests fail; back out: git reset --hard $before" >&2; exit 1; }
omarchy-plugin-validate . || { echo "validation fails; back out: git reset --hard $before" >&2; exit 1; }

./install.sh
systemctl --user restart omarchy-agent-session-watch.service
omarchy restart shell >/dev/null 2>&1 || true
# A new branch per upstream base: the rebased stack never needs a force push.
branch=xeno/local-$(git rev-parse --short origin/main)
git push --quiet fork "main:$branch"
echo "backed up as fork/$branch"
echo "upgraded; local stack:"; git log --oneline origin/main..main
