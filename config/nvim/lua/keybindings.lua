local global = vim.g
local key = vim.keymap

global.mapleader=' '
global.maplocalleader=','
-- override leader for vim-which-key
key.set('n', '<leader>', ':<c-u>WhichKey \'<Space>\'<CR>', {silent = true})

-- ctrl+z, ctrl+v
key.set('i', '<c-z>' ,'<c-o>:u<CR>', {silent = true})
key.set('i', '<c-v>', '<esc>:set paste<cr>a<c-r>=getreg(\'+\')<cr><esc>:set nopaste<cr>a', {silent = true})
-- delete without copying
key.set('n', 'x', '"_x')
key.set({'n', 'v'}, 'd', '"_d')
key.set('n', 'D', '"_D')

key.set('n', '<leader>t', ':NvimTreeToggle<CR>')
key.set('n', '<leader>u', ':UndotreeToggle<CR>')
key.set('n', '<leader>k', ':bnext<CR>')
key.set('n', '<leader>j', ':bprevious<CR>')
key.set('n', '<leader>q', ':qa!<CR>')
key.set('n', '<leader>os', ':setlocal spell! spelllang=en_us<CR>')
key.set('n', '<leader>or', ':so $MYVIMRC<CR>')
key.set('n', '<leader>of', ':Neoformat<CR>')
key.set('n', '<leader>ow', ':ToggleWorkspace<CR>')
key.set('n', '<leader>oa', ':ToggleAutosave<CR>')
key.set('n', '<leader>bw', ':w!<CR>')
key.set('n', '<leader>bx', ':bp <BAR> bd! #<CR>')
key.set('n', '<leader>bn', ':enew<CR>')
key.set('n', '<leader>wq', '<C-w>q')
key.set('n', '<leader>ws', ':split<cr>')
key.set('n', '<leader>wv', ':vsplit<cr>')
key.set('n', '<leader>wo', ':only<cr>')
key.set('n', '<leader>wh', '<C-w>h')
key.set('n', '<leader>wj', '<C-w>j')
key.set('n', '<leader>wk', '<C-w>k')
key.set('n', '<leader>wl', '<C-w>l')
key.set('n', '<leader>sc', ':set syn=cs<cr>')
key.set('n', '<leader>sf', ':set syn=fsharp<cr>')
key.set('n', '<leader>sj', ':set syn=javascript<cr>')
key.set('n', '<leader>st', ':set syn=typescript<cr>')
key.set('n', '<leader>ss', ':set syn=json<cr>')
key.set('n', '<leader>sx', ':set syn=xml<cr>')
key.set('n', '<leader>sb', ':set syn=sh<cr>')
key.set('n', '<leader>sm', ':set syn=terrafrom<cr>')
key.set('n', '<leader>sr', ':set syn=rust<cr>')
key.set('n', '<leader>sl', ':set syn=clojure<cr>')

-- vim-expand-region
key.set('', '+', '<Plug>(expand_region_expand)')
key.set('', '_', '<Plug>(expand_region_shrink)')

-- lines moving based on vim-unimpaired
key.set('n', '<a-j>', ']e', {remap = true})
key.set('n', '<a-k>', '[e', {remap = true})

-- phaazon/hop.nvim
key.set('n', 'f', ':HopWord<CR>')
key.set('n', '<leader>hf', ':HopWord<cr>')
key.set('n', '<leader>h1', ':HopChar1<cr>')
key.set('n', '<leader>h2', ':HopChar2<cr>')
key.set('n', '<leader>hl', ':HopLine<cr>')

-- Telescope
key.set('n', '<leader>bo', '<cmd>Telescope find_files hidden=true<cr>')
key.set('n', '<leader>ff', '<cmd>Telescope find_files hidden=true<cr>')
key.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
key.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
key.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')
key.set('n', '<leader>fs', '<cmd>Telescope current_buffer_fuzzy_find<cr>')
key.set('n', '<leader>fc', '<cmd>Telescope command_history<cr>')
