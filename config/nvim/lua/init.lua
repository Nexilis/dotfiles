local set=vim.opt
set.backup=true
set.swapfile=true
set.undofile=true
set.dir='$HOME/.config/nvim/swap//'
set.backupdir='$HOME/.config/nvim/backup//'
set.undodir='$HOME/.config/nvim/undo//'
set.termguicolors=true
set.encoding='utf-8'
set.langmenu='en_US.utf-8'
set.background='light'
vim.cmd [[
    colorscheme PaperColor
]]
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
set.wildignore:append('*/tmp/*,*.so,*.swp,*.')
set.shortmess:append('c')
set.number=true
set.timeoutlen=500
set.clipboard='unnamed,unnamedplus'
set.guifont='Hack Nerd Font Mono:h11'

require'nvim-web-devicons'.setup {}
require'hop'.setup()
require'nvim-tree'.setup {}
require'feline'.setup()
require'bufferline'.setup {}
require'nvim_comment'.setup()
require'gitsigns'.setup()
require'indent_blankline'.setup {}
