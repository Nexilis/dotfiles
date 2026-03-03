---
id: nvi-k6p4
status: closed
deps: []
links: []
created: 2026-03-03T09:52:53Z
type: chore
priority: 0
tags: [nvim, config, cleanup]
---
# Fix noice.nvim stale cmp override

Remove the ["cmp.entry.get_documentation"] = true override from noice.nvim opts. This was for nvim-cmp but the config uses blink.cmp — it does nothing.

