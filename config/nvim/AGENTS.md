# Agent Instructions for nvim Config

## Task Management with `tk`

Before doing any work on the user's behalf, you MUST follow this workflow:

1. **Define tasks first** — Use the `tk` CLI tool to create tasks for the work you plan to do:
   ```
   tk create "Task title"
   ```

2. **Confirm with the user** — Present the created tasks and wait for explicit user approval before proceeding. Do not start implementation until the user confirms.

3. **Execute the work** — Only after user confirmation, proceed with the implementation. Update tasks as you complete them:
   ```
   tk list         # review current tasks
   tk start <id>   # mark task as in progress
   tk close <id>   # mark task as completed
   ```

This applies to all changes: plugin configuration, keybindings, options, new files, refactoring, etc.

## Project Context

This is a Neovim configuration repository located at `~/.config/nvim`.

## Terminal buffers

Terminals run as normal buffers, so each gets a barbar top-bar tab.

- `<leader>bt` opens a full-window terminal. It runs `:only` first so the
  terminal fills the editor even when a split is open, then `:terminal` and
  `startinsert`. Side effect: it closes other splits.
- `<leader>ws` / `<leader>wv` detect a terminal buffer and open a split with a
  *fresh* terminal instead of mirroring the current one (a split alone shows the
  same buffer twice). For non-terminal buffers they split as before.
- Terminal-mode keymaps (set per buffer in `set_terminal_keymaps()`): `<esc>`
  and `<C-[>` both leave terminal mode. `<C-[>` needs its own map because
  Neovide (and the kitty keyboard protocol) sends it as a distinct key, so the
  `<esc>` map does not catch it. On macOS only, `<D-v>` (Cmd+V) pastes the `+`
  register into the running shell via `nvim_chan_send`.
- Insert-mode paste has one shortcut per platform (top of `init.lua`): macOS
  binds `<D-v>` (Cmd+V), other platforms bind `<c-v>` (Ctrl+V). On macOS `<c-v>`
  is intentionally left unbound so there is a single paste key and Ctrl+V keeps
  its default insert-literal behaviour.
- A `TermOpen` autocmd (augroup `user_terminal`) renames each plain terminal to
  `term-NNN` (random 3-digit) so tabs are distinguishable; barbar's tab label is
  derived from the `term://<cwd>//<pid>:<suffix>` buffer name, and this barbar
  version has no `name_formatter` or rename command, so rewriting the suffix is
  the only lever.

Gotchas, all hit during this work:
- `:terminal` consumes the rest of the command line as its shell command, so
  `:terminal | startinsert` passes `| startinsert` to the shell (fish errors).
  Run split / terminal / startinsert as separate `vim.cmd` calls.
- The rename skips toggleterm/lazygit terminals: their buffer name carries a
  `#toggleterm#<id>` marker that toggleterm uses to find them, and rewriting the
  suffix would clobber it. The guard is `if not name:match("#toggleterm#")`.
- Renaming keeps the `term://...//<pid>:` prefix, so the buffer name stays unique
  per terminal (pid) even if two random labels collide.

## Temporary Workarounds

- **`queries/lua/highlights.scm`** — Overrides the bundled Lua treesitter highlights query to fix a Neovim 0.12.2 bug (parser removed the `operator` field but queries still reference it). Must be in `queries/` (not `after/queries/`) because Neovim picks the first non-extending file in rtp order as the base query. Delete this file when upgrading to a Neovim version that fixes the query/parser mismatch.
