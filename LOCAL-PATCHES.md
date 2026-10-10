# Local patches (xenolaptop)

This checkout is upstream `mphaxise/omarchy-keepalive` (remote `origin`) with
local commits on `main`. They are backed up as branch `xeno/local` on
`chaosisnotrandomitisrhythmic/omarchy-keepalive` (remote `fork`).

`omarchy plugin update` cannot fast-forward a checkout with local commits, so
it stops and changes nothing. A new upstream version comes in with
`scripts/upgrade-from-upstream.sh` instead (fetch, rebase, test, validate,
reinstall, restart, back up).

## The stack, oldest first

| Commit | What | Upstream |
|---|---|---|
| Local patches on Keepalive 0.3.1 | Herdr tree in the panel, adoption of panes started in Herdr, `close` (/close-session into anamnesis), open focuses inside the Herdr window, watcher knows Herdr focus | local only |
| tests: list --json shape | the shape test knows the local keys | local only |
| reconcile: remove stale temp files | | PR #1 |
| reconcile: orphan on a gone Herdr only | | PR #2 |
| reconcile: seed an adopted record's harness ref | | PR #6 |
| reconcile: rebind an orphaned record | | PR #8 |
| open: never start a second copy | | PR #9 |
| open: a conversation closed out elsewhere | depends on the anamnesis patch | local only |
| store: one writer at a time | | PR #7 |
| watch: a quiet second costs nothing | | PR #3 |
| panel: poll the list only while open | | PR #4 |
| prune: a daily timer | | PR #5 |
| Session titles | `rename --title`; rows show the title and the tag; adoption leaves the pane's Herdr title (the tag) alone | local only |
| New session: paste screenshots | Ctrl+V images in the New field; IPC `newSession`, `newSessionWith`; `scripts/capture-new-session.sh` | local only |
| close-focused | /close-session for the Herdr pane on screen, second press confirms | local only |

When upstream merges one of the PRs, its commit drops out of the rebase on
its own (or resolves as empty: `git rebase --skip`).

## What lives outside this repo

- `~/.claude/hooks/herdr-title.py` (tracked in `~/.claude`): names and tags
  sessions; calls `omarchy-agent-session-core rename <id> <slug> --title`.
  Registered on SessionStart, UserPromptSubmit and Stop in
  `~/.claude/settings.json`.
- `~/.config/hypr/bindings.lua`: Super+Alt+N new session, Super+Shift+Alt+N
  new session from a region screenshot, Super+Alt+X close the session on
  screen (twice), Super+Ctrl+G the panel.
- `~/.config/omarchy/shell.json`: `showWhenEmpty: true` on the widget, so the
  icon stays to start sessions from.
