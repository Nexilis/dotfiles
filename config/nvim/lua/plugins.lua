local global=vim.g
local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')
Plug 'sheerun/vim-polyglot'
Plug('feline-nvim/feline.nvim', {branch = 'develop'})
Plug 'akinsho/bufferline.nvim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'phaazon/hop.nvim'
Plug 'ajh17/VimCompletesMe'
Plug 'terrortylor/nvim-comment' -- gcc to toggle comment
Plug 'tpope/vim-unimpaired' -- toggles yoh, yob, yow, yos
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-lua/plenary.nvim' -- dependency of telescope
Plug 'nvim-telescope/telescope.nvim'
Plug 'thaerkh/vim-workspace'
Plug 'liuchengxu/vim-which-key'
Plug 'mbbill/undotree'
Plug 'terryma/vim-expand-region'
Plug 'kyazdani42/nvim-web-devicons' -- file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'lukas-reineke/indent-blankline.nvim' -- show | every 4 spaces
Plug 'sbdchd/neoformat'
vim.call('plug#end')

vim.cmd [[
    colorscheme PaperColor
]]

global.plug_shallow=1

global.neoformat_basic_format_align=1
global.neoformat_basic_format_retab=1
global.neoformat_basic_format_trim=1

home=os.getenv( "HOME" )
global.workspace_create_new_tabs=0
global.workspace_session_directory=home..'/.config/nvim/sessions/'
global.workspace_session_disable_on_args=1
global.workspace_undodir=home..'/.config/nvim/undo/workspace'
global.workspace_autosave_untrailspaces=0
global.workspace_autosave_always=1

global.undotree_WindowLayout=2
global.undotree_SetFocusWhenToggle=1

require'nvim-web-devicons'.setup {}
require'hop'.setup()
require'nvim-tree'.setup {}
require'feline'.setup()
require'bufferline'.setup {}
require'nvim_comment'.setup()
require'gitsigns'.setup()
require'indent_blankline'.setup {}
