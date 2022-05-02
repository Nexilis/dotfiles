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
Plug 'folke/which-key.nvim'
Plug 'mbbill/undotree'
Plug 'terryma/vim-expand-region'
Plug 'kyazdani42/nvim-web-devicons' -- file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'lukas-reineke/indent-blankline.nvim' -- show | every 4 spaces
Plug 'sbdchd/neoformat'
vim.call('plug#end')

require'which-key'.setup {}
require'nvim-web-devicons'.setup {}
require'hop'.setup()
require'nvim-tree'.setup {}
require'feline'.setup()
require'bufferline'.setup {}
require'nvim_comment'.setup()
require'gitsigns'.setup()
require'indent_blankline'.setup {}

vim.cmd [[
    colorscheme PaperColor
]]

global.plug_shallow=1

global.neoformat_basic_format_align=1
global.neoformat_basic_format_retab=1
global.neoformat_basic_format_trim=1

local home=os.getenv( "HOME" )
global.workspace_create_new_tabs=0
global.workspace_session_directory=home..'/.config/nvim/sessions/'
global.workspace_session_disable_on_args=1
global.workspace_undodir=home..'/.config/nvim/undo/workspace'
global.workspace_autosave_untrailspaces=0
global.workspace_autosave_always=1

global.undotree_WindowLayout=2
global.undotree_SetFocusWhenToggle=1

local keymap={
    k = {'<cmd>bnext<cr>', 'buffer-next'},
    j = {'<cmd>bprevious<cr>', 'buffer-previous'},
    q = {'<cmd>qa!<cr>', 'quit'},
    u = {'<cmd>UndotreeToggle<cr>', 'undo-tree-toggle'},
    t = {'<cmd>NvimTreeToggle<cr>', 'file-tree-toggle'},
    o = {
        name = '+OPTIONS',
        r = {'<cmd>so $MYVIMRC<cr>', 'config-reload'},
        f = {'<cmd>Neoformat<cr>', 'autoformat'},
        w = {'<cmd>ToggleWorkspace<cr>', 'workspace-toggle'},
        a = {'<cmd>ToggleAutosave<cr>', 'autosave-toggle'},
        s = {'<cmd>setlocal spell! spelllang=en_us<cr>', 'spellchecker-toggle'},
    },
    b = {
        name = '+BUFFER',
        w = {'<cmd>w!<cr>', 'write'},
        o = {'<cmd>Telescope find_files hidden=true<cr>', 'open'},
        x = {'<cmd>bp <bar> bd! #<cr>', 'close'},
        n = {'<cmd>enew<cr>', 'new'},
    },
    h = {
        name = '+HOP',
        f = {'<cmd>HopWord<cr>', 'word'},
        l = {'<cmd>HopLine<cr>', 'line'},
        s = {'<cmd>HopChar1<cr>', 'single-char'},
        t = {'<cmd>HopChar2<cr>', 'two-chars'},
    },
    f = {
        name = '+FIND',
        f = {'<cmd>Telescope find_files hidden=true<cr>', 'file'},
        g = {'<cmd>Telescope live_grep<cr>', 'grep-live'},
        b = {'<cmd>Telescope buffers<cr>', 'buffers'},
        h = {'<cmd>Telescope help_tags<cr>', 'help'},
        s = {'<cmd>Telescope current_buffer_fuzzy_find<cr>', 'search-fuzzy'},
        c = {'<cmd>Telescope command_history<cr>', 'command-history'},
    },
    w = {
        name = '+WINDOW',
        q = {'<c-w>q', 'close'},
        s = {'<cmd>split<cr>', 'split-horizontal'},
        v = {'<cmd>vsplit<cr>', 'split-vertical'},
        h = {'<c-w>h', 'focus-left'},
        j = {'<c-w>j', 'focus-down'},
        k = {'<c-w>k', 'focus-up'},
        l = {'<c-w>l', 'focus-right'},
        o = {'<cmd>only<cr>', 'only-current-window'},
    },
    s = {
        name = '+SYNTAX',
        c = {'<cmd>set syn=cs<cr>', 'c#'},
        f = {'<cmd>set syn=fsharp<cr>', 'f#'},
        j = {'<cmd>set syn=javascript<cr>', 'js'},
        t = {'<cmd>set syn=typescript<cr>', 'ts'},
        s = {'<cmd>set syn=json<cr>', 'json'},
        x = {'<cmd>set syn=xml<cr>', 'xml'},
        b = {'<cmd>set syn=sh<cr>', 'bash'},
        m = {'<cmd>set syn=terrafrom<cr>', 'terraform'},
        r = {'<cmd>set syn=rust<cr>', 'rust'},
        l = {'<cmd>set syn=clojure<cr>', 'clojure'},
    }
}
require'which-key'.register(keymap, { prefix = "<leader>" })
