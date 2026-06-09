# AGENTS.md

Repo-specific context for AI agents. General coding and commit conventions
come from the agent's own config; this file only records what is true about
this repo.

## What this is

Personal dotfiles. Solo repo, no PR flow; commit directly to `master`.

- Real local path is `~/code/gh/prv/dotfiles`. Bootstrap scripts and the README
  are now self-locating / path-independent, so the clone can live anywhere.
- Primary machine is macOS. `bootstrap-macos.sh` covers it (Homebrew + optional
  Brewfile + linking); `bootstrap-fedora.sh` / `bootstrap-ubuntu.sh` cover Linux.

## Layout

- `config/<app>/` mirrors `~/.config/<app>/` (kitty, fish, nvim, helix, yazi,
  zed, ghostty, alacritty, and more).
- `home/` holds files that live in `~`.
- `bootstrap/` holds provisioning scripts. `bootstrap-macos.sh`,
  `bootstrap-fedora.sh`, and `bootstrap-ubuntu.sh` are the entry points (all
  self-locating); `_config.sh`/`_link.sh` deploy configs; `*.bin.sh` install
  individual tools (Linux); macOS installs come from a `Brewfile` via
  `brew bundle` if present.
- `.tickets/` holds `tk` tickets.

## Deploy mechanism (symlinks)

Configs are deployed as symlinks into this repo, so editing a live file edits
the repo file and changes are tracked directly. `bootstrap/_link.sh` does the
linking (cross-platform, self-locating, idempotent): `config/* -> ~/.config/*`
and `home/* -> ~/`. It is safe to rerun. It skips any target whose content
differs from the repo unless `--force`, and backs up anything it replaces to
`<target>.bak.<timestamp>`. Use `--dry-run` to preview. `_config.sh` now just
delegates to `_link.sh` (it no longer does `rm -rf` + `cp -r`).

Migration tracked in `tk` ticket `dot-4u09`. All `config/*` and `home/*`
entries are now symlinked (no skips). App-generated state inside symlinked
dirs is kept out of git via `.gitignore`. Per-dir reconcile details live in
`tk show dot-4u09`.

## Tickets

Tasks are tracked with the `tk` CLI; tickets are markdown in `.tickets/`.
`tk list`, `tk show <id>`, `tk add-note <id> "..."`, `tk status <id> <state>`.
Keep full task state in the ticket and reference it here, do not duplicate it.

`.tickets/` is local-only: gitignored and not committed (the repo is public).
The files live on disk so `tk` works; they are just never tracked.

## Tools

- `config/kitty/tools/contrast/` is a Go module that reports WCAG contrast of a
  kitty theme against its background. Run `just check-all` from that dir.
- `config/kitty/tools/colorpick/` is a Go module that reports the most common
  colors inside a rectangular region of a PNG. Use it to ground-truth which
  palette color an app paints in a screenshot before changing a theme, instead
  of guessing. `just pick <image> <x> <y> <w> <h> [topN]`.

## App theming notes

- The kitty `*.auto.conf` palette tunes the ANSI colors to read as *foreground*
  text on the background (AA). TUIs that paint an ANSI color as a *background*
  (lazygit selected line, yazi tabs) then get dark default text on a dark-ish
  blue, which fails contrast. A single ANSI slot can't be both, so those are
  fixed per-app, not in the kitty palette:
  - `config/lazygit/config.yml`: `selectedLineBgColor: [reverse]` (reverse is
    theme-agnostic; readable in both light and dark kitty).
  - `config/yazi/theme.toml`: `[tabs]` active/inactive use fixed hex colors with
    their own background, so they read regardless of the kitty background.
- lazygit on macOS reads `~/Library/Application Support/lazygit`, not
  `~/.config`. To keep it inside the symlink migration, `config/fish/config.fish`
  sets `LG_CONFIG_FILE=$HOME/.config/lazygit/config.yml`, so lazygit loads the
  repo-symlinked config. State (`state.yml`) still lives in Application Support.
- Claude Code's own theme colors (the dark user-message chip, the amber "auto
  mode on" hint, dim secondary text) are NOT from the kitty palette. They are
  overridable only through a custom theme, so `claude/themes/` ships two:
  `cvlight.json` (base `light`) and `cvdark.json` (base `dark`), each overriding
  `userMessageBackground`, `autoAccept`, and `inactive`. `_link.sh` links the
  dir to `~/.claude/themes` (a nested link; the rest of `~/.claude` is state and
  must not be symlinked). Claude Code hot-reloads that dir.
  - Trade-off: a custom theme pins one base, so it does NOT follow the OS
    light/dark like the default `auto`. Switch manually with `/theme` (pick
    "CV Light" or "CV Dark") when you flip appearance. The active selection is
    stored by Claude Code in an undocumented spot, so it is not committed here.
  - `userMessageBackground` only shows in fullscreen rendering mode (`/tui
    fullscreen`); inline mode has no message chip.
  - Gotcha: a brand-new theme file needs a Claude Code restart to appear in
    `/theme` the first time (the watcher only catches changes to a dir it
    already scanned at startup). Later edits to an existing file hot-reload.

## Repo notes

- `config/nvim/lazy-lock.json` shows up untracked; it is noise, do not commit it.
