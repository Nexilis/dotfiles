# AGENTS.md

Repo-specific context for AI agents. General coding and commit conventions
come from the agent's own config; this file only records what is true about
this repo.

## Language: code is always English

Everything inside a code file is English, with no exceptions: identifiers,
comments, commit messages, and **every string the program prints** (prompts,
errors, progress, report headings). The owner is Polish and chats in Polish, which
is not a reason to emit Polish from a script; a message printed by code is part of
the code. Same rule holds in the private notes repo (`private-sync/AGENTS.md`).
Polish belongs in notes and in conversation, never in a `.sh`, `.go`, `.lua`,
`.fish`, or `justfile`.

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
  individual tools (Linux). macOS package installs are group-based, see below.
- `.tickets/` holds `tk` tickets.

## macOS packages: manifest + groups

`bootstrap-macos.sh` runs three steps in this order: stage 0 (Homebrew,
`brew trust` for the taps, `just`), then `_link.sh`, then the package groups via
`bootstrap/justfile`. What gets installed is NOT decided in the script.

**Configs are linked BEFORE packages, deliberately.** Package installs are the
long, noisy, interruptible part. When that half is cancelled or dies, the shell,
editor and terminal config are already in place and the machine is usable. Do not
move `_link.sh` back to the end.

- **`bootstrap/macos-packages.txt`** is the manifest and the source of truth.
  Columns are `group  kind  package  [# note]`, whitespace-separated; `kind` is
  `formula`, `cask`, or `script` (the last one runs `bootstrap/macos/<pkg>.sh`,
  which is how the non-brew installers rustup / antigravity / gocryptfs are
  wired in). Only leaves belong here, never Homebrew dependencies. The rejected
  and parked packages are listed at the bottom with reasons, so the "do not
  reinstall this" knowledge sits next to the list.
- **`bootstrap/macos/install-group.sh`** installs by group: `--list`, `--all`,
  `--interactive`, `--dry-run`. A failed batch is retried per package so the log
  names the one that broke, and no failure aborts the rest of the run.
- **`bootstrap/justfile`** exposes one recipe per group plus `pick`, `all`,
  `groups`, `link`. A bare `just` in `bootstrap/` lists everything, which is the
  point: nothing has to be remembered on a fresh Mac.
- The **`work`** group (macfuse + gocryptfs, keeper, zed, snapzy, slumber,
  googleworkspace-cli) defaults to **no** in `--interactive`; the private Mac
  runs without it. Hammerspoon is NOT in it: it lives in `desktop` and belongs on
  both machines.

**Consent rules for `--interactive` (learned the hard way).** The first real run
installed groups nobody approved. Two causes, both fixed, neither to be undone:

- Answers are read from **`/dev/tty`**, never from stdin. `just` runs the recipe
  through a shell, so stdin is whatever the caller left behind; reading it made
  every prompt return instantly and the whole list flew past unanswered.
- There is **no fallback to defaults**. The old code printed "taking the
  defaults" on end of input, which answered YES for 11 of 12 groups on nobody's
  behalf, `work` (macfuse, a kernel extension) included once answers shifted by
  one. No terminal is now a hard error, exit 3. Installing unapproved software is
  worse than doing nothing.
- The chosen groups are restated and confirmed once more before the first install.

Gotcha: do not name a bash array `GROUPS`. It is a bash special variable holding
the user's unix group IDs, and assigning to it silently gives you group numbers
instead of your values. `install-group.sh` uses `SELECTED`.

Gotcha: macOS ships bash 3.2, where `"${arr[@]}"` on an empty array trips
`set -u`. Empty-array expansions need the `${arr[@]+"${arr[@]}"}` guard.

The private-side counterpart is `private-sync/tech/apple-macbook.md`: the four
commands to start a fresh Mac, the manual steps no script can do (Privacy &
Security permissions per app, `.git` in the Syncthing `.stignore`, FileVault,
macFUSE reduced security), and the parked software list.

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

## Neovide

Neovide comes from the `neovide-app` **cask** (homebrew-cask), not the
homebrew-core `neovide` **formula**. The formula is a CLI-only bottle that leaves
`Neovide.app` buried in the Cellar (never in `/Applications`); the cask installs
the signed app to `/Applications` and links the `neovide` binary onto PATH, so we
get both. Set in `macos-packages.txt`, group `editors`.

**Do not reintroduce a custom Dock icon.** We used to ship an inset-squircle
`.icns` and apply it as a macOS custom icon (FinderInfo xattr + Icon resource),
because the stock upstream icon is a full-bleed cog that looks oversized and
plate-less next to native apps. It was removed: the icon reverts to stock on
launch anyway, and Neovide runs almost all day here, so the machinery cost more
than it delivered. Gone with it: `bootstrap/macos/neovide-app.sh`, the vendored
`.icns` and PNG, the `neovide-icon` just recipe, the manifest `script` row, and
the reapply hook that used to live in the `u` fish function.

## Karabiner-Elements

`config/karabiner/karabiner.json` does three things: `caps_lock` -> Hyper, a
right `cmd`/`option` swap globally, and a left `cmd`/`option` swap plus a device
ignore for specific external keyboards.

**`caps_lock` -> Hyper must stay global, on every keyboard.** It was briefly
scoped with a `device_if` condition (built-in keyboard plus one external), on the
assumption that Hyper only matters where Hammerspoon runs and that the private
Mac would go without Hammerspoon. Both halves were wrong: Hammerspoon is needed
on the private Mac as well (the virtual desktop shortcuts are not optional), and
scoping silently kills Hyper the moment a keyboard outside the list is attached,
which reads as "Hammerspoon did not load my config". Reverted; do not scope it
again.

**kanata was evaluated as a replacement and rejected.** On macOS it still needs
the Karabiner DriverKit VirtualHIDDevice driver, so it does not remove the
Karabiner dependency, and it only offers `macos-dev-names-include` /
`macos-dev-names-exclude` (which devices to grab). It cannot give *different
mappings per keyboard*, which this config depends on.

## BetterCmdTab

Replaces the macOS Cmd+Tab switcher. The reason it is here: the built-in one
skips minimized windows unless you hold `option` and release `cmd` before it,
and that trick cannot be automated from Karabiner. Karabiner emits modifiers
wrapped around the mapped key, so `option` would go up before `cmd` does, and
`to.sticky_modifier` does not document when it clears. The fix belongs in an app
that reopens the windows, not in a key remap.

`config/bettercmdtab/config.json` is tracked and symlinked by `_link.sh` like
any other `config/*` dir. This works because the app resolves symlinks before
its atomic write (`ConfigFile.swift`: `data.write(to: url.resolvingSymlinksInPath(),
options: .atomic)`), so the temp+rename replaces the repo file instead of eating
the link. The sync is two-way and live: edits to the file apply within a second,
GUI changes are written back after a 500 ms debounce plus a flush at quit. The
round trip is byte-stable, so no-op churn does not show up in `git status`.

**A fresh machine needs no import step.** The only thing that arms the sync is
the file existing: `armWatcher()` opens `config.json` and sets `watchingFile`,
with no preference gating it. So `_link.sh` running before the first launch is
enough, and the settings apply on their own. The Settings -> General -> Backup ->
Configuration file -> Create button only writes the file the first time, on a
machine that does not have it yet. The plist domain
`pro.bettercmdtab.BetterCmdTab` stays the primary store; the JSON is the synced
mirror of it.

Two things to know:

- **After moving or relinking the file, restart the app.** It watches an open
  file descriptor, so the live config keeps pointing at the old inode until the
  watcher re-arms; writes still land in the repo, reads do not.
- **Never track the plist domain instead.** `~/Library/Preferences/pro.bettercmdtab.BetterCmdTab.plist`
  is owned by `cfprefsd` (which rewrites it out from under a symlink) and it
  carries volatile state: an update-check timestamp and `Switcher.recentlyClosed`
  with app names and window titles. This repo is public.

`schema.json` sits next to the config, is generated from the running build, and
is gitignored; the app rewrites it when absent, so a fresh clone self-heals.

**The file does not carry the keybindings.** The 18 `BetterShortcuts_*` keys and
`Switcher.disabledSymbolicHotKeys` (which native hotkeys the app took over) exist
only in the plist domain. The Settings export is no way around it: it takes the
same key set as the config file, which upstream's config reference states
outright. So `config.json` covers preferences, `appExceptions`,
`scopedShortcutList` and `shortcutOverrides`, and every actual key assignment
falls back to the app default on a fresh machine. Nothing is lost while the
bindings are the defaults, which is the case today. Tracked in `tk dot-v0b2`.

## Hammerspoon

Installed on every machine, private included: it carries the virtual desktop
switching shortcuts, which are daily-use. It sits in the `desktop` package group,
not `work`.

**Diagnosing "Hammerspoon did not load my config".** Check whether the `iss`
process is running: `pgrep -fl hammerspoon/iss/iss`. Only `init.lua` starts it,
so a live `iss` proves the config loaded and the problem is downstream, almost
always the `Hyper` modifier not arriving (see Karabiner) or Secure Event Input.
Reloading is awkward by design: the AppleScript/IPC bridges are off and
`init.lua` hides the default menubar icon, so there is no tool-driven reload;
quit and relaunch the app.

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
  overridable only through a custom theme, so `home/.claude/themes/` ships two:
  `cvlight.json` (base `light`) and `cvdark.json` (base `dark`), each overriding
  `userMessageBackground`, `autoAccept`, and `inactive`. `_link.sh` links the
  dir to `~/.claude/themes` (a nested link; the rest of `~/.claude` is state and
  must not be symlinked, so `.claude` is listed in `NESTED_ONLY` and skipped by
  the wholesale `home/*` pass). Claude Code hot-reloads that dir.
  - Trade-off: a custom theme pins one base, so it does NOT follow the OS
    light/dark like the default `auto`. Switch manually with `/theme` (pick
    "CV Light" or "CV Dark") when you flip appearance. The active selection is
    stored by Claude Code in an undocumented spot, so it is not committed here.
  - `userMessageBackground` only shows in fullscreen rendering mode (`/tui
    fullscreen`); inline mode has no message chip.
  - Gotcha: a brand-new theme file needs a Claude Code restart to appear in
    `/theme` the first time (the watcher only catches changes to a dir it
    already scanned at startup). Later edits to an existing file hot-reload.

## Neovim terminal mode

Terminal-mode keymaps live in `config/nvim/lua/init.lua` (`set_terminal_keymaps`,
run from a `term://*` TermOpen autocmd). ESC and `<C-[>` are deliberately NOT
mapped there: TUIs running inside the terminal (e.g. omp) need ESC themselves.

**Gotcha (hard-won):** under Neovide, ESC and `<C-[>` arrive as the *same* key, so
any `<C-[>` terminal map also swallows ESC. You cannot have both "ESC reaches the
TUI" and "Ctrl+[ leaves terminal mode" in Neovide; they are one keystroke. Leave
terminal mode with `<C-w>w` (jump to next window) or the built-in `<C-\><C-n>`. Do
not re-add an `<esc>`, `<C-[>`, or `jk` terminal-mode exit unless you want ESC
captured again (which breaks TUIs like omp).

## omp (oh-my-pi AI coding agent)

Current AI-agent tryout (replaced maki and pi). Installed from `can1357/tap`
via `bootstrap-macos.sh`; `omp/config.yml` and `omp/models.yml` are linked into
`~/.omp/agent/` by `_link.sh` (only these files; the dir also holds the auth
store and sessions). Model auth is the exported `OPENROUTER_API_KEY` fish
universal variable. `models.yml` pins the OpenRouter upstream provider for
glm-5.2 to Novita (`openRouterRouting.only`); may move to an OpenRouter-side
preset later.

Gotchas learned the hard way:

- **web_search is broken in published builds** (baked CI `__dirname` for the
  `header-generator` package). Local workaround: the package is copied under
  `/Users/runner/work/oh-my-pi/oh-my-pi/node_modules/`. Cleanup tracked in
  `tk dot-l6vh`; once upstream fixes bundling, remove `/Users/runner`.
- **omp discovery inherits Claude Code config**, including plugin MCP servers
  from `~/.claude/plugins/cache/` — and it ignores Claude's `enabledPlugins`
  disable flag. To turn a discovered server off, add its **plugin-qualified**
  name (`<plugin>:<server>`) to `disabledServers` in `~/.omp/agent/mcp.json`;
  the bare server name does not match.

## Work secrets

Work secrets use a gocryptfs vault, mounted on demand via the `dec` / `unmount`
aliases in `config/fish/config.fish`. Install steps are in `bootstrap-macos.sh`.
Setup details and the rationale for the tooling choice are kept local-only in
`tk dot-0te4`, not in this public repo.

## Repo notes

- `config/nvim/lazy-lock.json` shows up untracked; it is noise, do not commit it.
- **`home/.gitconfig`: section order is load-bearing, do not "tidy" it.** The
  generic `[credential]` block MUST stay above the per-URL ones. Each block
  starts with an empty `helper =`, which resets the accumulated helper list, and
  git applies the blocks in file order. With the generic block last, its reset
  wipes the GitHub-specific `gh auth git-credential` and leaves
  git-credential-manager (the Azure DevOps one) handling github.com. Verified
  with `git credential fill` against both orderings: generic-first invokes the
  gh helper, generic-last invokes gcm. Something occasionally rewrites the file
  into the wrong order (a `git config --global` write reorders sections), so if
  `.gitconfig` turns up modified with only a reordering, discard it rather than
  commit it.
