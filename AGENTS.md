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

## Public repo: secrets hygiene

This repo is public. Do not commit secrets here, and be just as careful with
"semi-secrets": absolute paths that expose account or folder layout, internal
hostnames, and step-by-step notes on how local security is set up. None of that
belongs in a public file. When something is useful but too revealing, keep it
local-only (gitignored, like `.tickets/`) or in `tk`, and leave only a short
pointer here. See "Work secrets" for an example of that split.

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

## macOS app icons

- Neovide comes from the `neovide-app` **cask** (homebrew-cask), not the
  homebrew-core `neovide` **formula**. The formula is a CLI-only bottle that
  leaves `Neovide.app` buried in the Cellar (never in `/Applications`); the cask
  installs the signed app to `/Applications` and links the `neovide` binary onto
  PATH, so we get both. Set in `bootstrap-macos.sh`.
- We override neovide's icon with an **inset squircle**. Its stock upstream icon
  is a full-bleed cog on a transparent background, so next to native macOS apps
  (inset rounded-rectangle with a plate) it looks oversized and plate-less in the
  Dock and cmd+tab. `bootstrap/macos/neovide-app.sh` applies our own
  `bootstrap/macos/neovide.icns` (generated from the vendored
  `neovide-256x256.png`; regen recipe in the script header) as a macOS **custom
  icon** via `NSWorkspace -setIcon:forFile:` (a FinderInfo xattr + Icon resource),
  not by overwriting the bundle's `.icns` (which would break the cask app's
  hardened-runtime signature; `codesign --verify` still passes after). The full
  "why" is in the script header. `bootstrap-macos.sh` runs it right after the
  cask install (non-fatal; it is cosmetic). Originally migrated from
  `work-sync/operations/scripts/shell/`.
- **Gotcha: `brew upgrade --cask neovide-app` reverts the icon to stock.** The
  upgrade replaces the whole `.app` bundle, dropping the custom-icon attributes.
  Re-run `bootstrap/macos/neovide-app.sh` to reapply (the symptom is the oversized
  plate-less icon back in the Dock/cmd+tab while the Applications list may still
  show a cached correct one). If the Dock stays stale after, log out/in to clear
  the icon-services cache.

## Hammerspoon

Config is `config/hammerspoon/init.lua`. `Hyper` = `cmd+ctrl+alt+shift`.
Keybindings:

- `Hyper+h/j/k/l/f/n`: window moves via MiroWindowsManager (left/down/up/right,
  fullscreen, next screen).
- `Hyper+o`: tile standard windows on the focused screen. 1 window maximizes;
  2 windows cycle 50/50 -> 30/70 -> 70/30 (a repeat at 50/50 swaps sides);
  3+ windows use main+stack (one big left, the rest stacked right) and each
  repeat rotates which window is main.
- `Hyper+Tab`: MRU application switcher (`hs.chooser`). App-level on purpose; the
  code comment explains why window-level froze (HS #3712 all-windows AX stall).
- `iss` (`Hyper+arrow`): instant Space switch. Separate Go binary
  (github.com/joshuarli/iss), built and launched from `init.lua`.

Gotchas:

- **Reload**: the AppleScript/IPC bridges are off, so a tool can't reload it.
  Reload from the menubar space-number icon -> Reload.
- **Secure Event Input** blocks all CGEventTaps, which kills `iss` (Hyper+arrow)
  and Hyper+Tab. Apps sometimes leak it on a dead pid. The menubar surfaces the
  current holder; reboot clears a stuck one.

**Dead end - "move focused window to space N" is not possible cleanly.** We tried
`Hyper+1..9` -> `hs.spaces.moveWindowToSpace`. Apple disabled the private Spaces
API in macOS 15 Sequoia and it is still gone in macOS 26 Tahoe: the call returns
`true` but no-ops (so an alert "succeeds" while the window never moves). Upstream:
Hammerspoon issues #3636 and #3698. The only userspace workaround is a visible
hack: synthesize a mouse-down on the titlebar, fire the native Mission Control
space-switch shortcut so the held window is dragged along, then release. It
always follows the window (no move-only), rides the ~0.5-0.7s animated switch and
moves the cursor, needs native MC shortcuts enabled, and Electron/atypical-titlebar
apps (Slack) need an extra 1px drag step. Clean, invisible moves need the
SIP-disabled route (yabai), which `iss` exists to avoid. Decided not worth it;
drag windows by hand. A short pointer sits where the binding would go in
`init.lua`.

## App theming notes

- The kitty `*.auto.conf` palette tunes the ANSI colors to read as *foreground*
  text on the background (AA). TUIs that paint an ANSI color as a *background*
  (lazygit selected line, yazi tabs) then get dark default text on a dark-ish
  blue, which fails contrast. A single ANSI slot can't be both, so those are
  fixed per-app, not in the kitty palette:
  - `config/lazygit/config.yml`: `selectedLineBgColor: [reverse]` (reverse is
    theme-agnostic; readable in both light and dark kitty).
  - `config/yazi/theme.toml`: `[tabs]`, `[mode]`, and `[which]` (the which-key
    prefix popup) use fixed hex fg+bg with their own background, so they read
    regardless of the kitty background.
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

## Work secrets

Work secrets use a gocryptfs vault, mounted on demand via the `dec` / `unmount`
aliases in `config/fish/config.fish`. Install steps are in `bootstrap-macos.sh`.
Setup details and the rationale for the tooling choice are kept local-only in
`tk dot-0te4`, not in this public repo.

## Repo notes

- `config/nvim/lazy-lock.json` shows up untracked; it is noise, do not commit it.
