local global = vim.g
local key = vim.keymap

global.mapleader=' '
global.maplocalleader=','

-- ctrl+z, ctrl+v
key.set('i', '<c-z>' ,'<c-o>:u<cr>', {silent = true})
key.set('i', '<c-v>', '<esc>:set paste<cr>a<c-r>=getreg(\'+\')<cr><esc>:set nopaste<cr>a', {silent = true})
-- delete without copying
key.set('n', 'x', '"_x')
key.set({'n', 'v'}, 'd', '"_d')
key.set('n', 'D', '"_D')

-- phaazon/hop.nvim
key.set('n', 'f', ':HopWord<cr>', {silent = true})

-- vim-expand-region
key.set('', '+', '<Plug>(expand_region_expand)')
key.set('', '_', '<Plug>(expand_region_shrink)')

-- lines moving based on vim-unimpaired
key.set('n', '<a-j>', ']e', {remap = true})
key.set('n', '<a-k>', '[e', {remap = true})

