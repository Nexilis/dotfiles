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

## Deploy mechanism (mid-migration)

Today `bootstrap/_config.sh` deploys configs by `rm -rf` on the target then
`cp -r` from the repo. So the live config is a copy that drifts from the repo,
and edits must be copied back by hand before committing.

We are switching to symlinks so the live config points at the repo and edits
are tracked directly. Tracked in `tk` ticket `dot-4u09`.

Done so far (the proof case): `~/.config/kitty` is a symlink to `config/kitty`
in this repo, so editing the live file edits the repo file directly.

Caveat: `_config.sh` still does `rm -rf` + `cp -r`. Running it now would delete
the kitty symlink and replace it with a copy. Do not run it until the migration
covers bootstrap. Remaining work lives in `tk show dot-4u09`.

## Tickets

Tasks are tracked with the `tk` CLI; tickets are markdown in `.tickets/`.
`tk list`, `tk show <id>`, `tk add-note <id> "..."`, `tk status <id> <state>`.
Keep full task state in the ticket and reference it here, do not duplicate it.

## Tools

- `config/kitty/tools/contrast/` is a Go module that reports WCAG contrast of a
  kitty theme against its background. Run `just check-all` from that dir.

## Repo notes

- `config/nvim/lazy-lock.json` shows up untracked; it is noise, do not commit it.
