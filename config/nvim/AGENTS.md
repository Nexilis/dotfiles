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

## Temporary Workarounds

- **`queries/lua/highlights.scm`** — Overrides the bundled Lua treesitter highlights query to fix a Neovim 0.12.2 bug (parser removed the `operator` field but queries still reference it). Must be in `queries/` (not `after/queries/`) because Neovim picks the first non-extending file in rtp order as the base query. Delete this file when upgrading to a Neovim version that fixes the query/parser mismatch.
