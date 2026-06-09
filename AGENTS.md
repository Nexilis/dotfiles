# AGENTS.md

Repo-specific context for AI agents. General coding and commit conventions
come from the agent's own config; this file only records what is true about
this repo.

## What this is

Personal dotfiles. Solo repo, no PR flow; commit directly to `master`.

- Real local path is `~/code/gh/prv/dotfiles`. The README still points at the
  old `~/proj/dotfiles`, and bootstrap paths are hardcoded to it, so treat the
  README path as stale.
- Primary machine is macOS. The bootstrap scripts are Linux-only (see below).

## Layout

- `config/<app>/` mirrors `~/.config/<app>/` (kitty, fish, nvim, helix, yazi,
  zed, ghostty, alacritty, and more).
- `home/` holds files that live in `~`.
- `bootstrap/` holds provisioning scripts. `bootstrap-fedora.sh` and
  `bootstrap-ubuntu.sh` are the entry points; `_config.sh` deploys configs;
  `*.bin.sh` install individual tools.
- `.tickets/` holds `tk` tickets.

## Deploy mechanism (symlinks)

Configs are deployed as symlinks into this repo, so editing a live file edits
the repo file and changes are tracked directly. `bootstrap/_link.sh` does the
linking (cross-platform, self-locating, idempotent): `config/* -> ~/.config/*`
and `home/* -> ~/`. It is safe to rerun. It skips any target whose content
differs from the repo unless `--force`, and backs up anything it replaces to
`<target>.bak.<timestamp>`. Use `--dry-run` to preview. `_config.sh` now just
delegates to `_link.sh` (it no longer does `rm -rf` + `cp -r`).

Migration tracked in `tk` ticket `dot-4u09`. Most entries are linked; a few
dirs whose live content has diverged from the repo are still skipped pending
manual reconcile (which side wins). The skip list and per-dir details live in
`tk show dot-4u09`.

## Tickets

Tasks are tracked with the `tk` CLI; tickets are markdown in `.tickets/`.
`tk list`, `tk show <id>`, `tk add-note <id> "..."`, `tk status <id> <state>`.
Keep full task state in the ticket and reference it here, do not duplicate it.

## Tools

- `config/kitty/tools/contrast/` is a Go module that reports WCAG contrast of a
  kitty theme against its background. Run `just check-all` from that dir.

## Repo notes

- `config/nvim/lazy-lock.json` shows up untracked; it is noise, do not commit it.
