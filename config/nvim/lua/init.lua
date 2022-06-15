g = vim.g
set = vim.opt
fn = vim.fn
key = vim.keymap
au = vim.api.nvim_create_autocmd
home = os.getenv("HOME")

set.dir=home..'/.config/nvim/swap//'
set.backupdir=home..'/.config/nvim/backup//'
set.undodir=home..'/.config/nvim/undo//'
set.backup=true
set.swapfile=true
set.undofile=true
set.termguicolors=true
set.encoding='utf-8'
set.langmenu='en_US.utf-8'
set.background='light'
set.list=true
set.listchars = {tab = '▸ ', trail = '·'}
set.mousehide=true
set.mouse='a'
set.wrap=false
set.backspace='2'
set.ignorecase=true
set.smartcase=true
set.tabstop=4
set.shiftwidth=4
set.softtabstop=4
set.expandtab=true
set.colorcolumn='120'
set.completeopt='menuone,noinsert,noselect'
set.formatoptions:remove('t')
set.path:append('**')
set.wildignore:append('*/tmp/*,*/cache/*,*.so,*.swp,*.')
set.shortmess:append('c')
set.number=true
set.timeoutlen=500
set.clipboard='unnamed,unnamedplus'
set.guifont='Hack Nerd Font Mono:h11'

au('BufWritePost', {
  pattern = 'plugins.lua',
  command = 'source <afile> | PackerCompile',
})

au({'BufRead', 'BufNewFile'}, {
  pattern = '*.csx',
  callback = function() vim.bo.filetype = 'cs' end,
})

au('TextYankPost', {
  pattern = '*',
  callback = function() vim.highlight.on_yank({higroup="IncSearch", timeout=150}) end,
})

vim.cmd([[
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
]])
