local fn = vim.fn
local installPath = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(installPath)) > 0 then
    fn.system {
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        installPath,
    }
    print 'Installing packer. Restart Neovim and run :PackerSync.'
end
local ok, packer = pcall(require, 'packer')
if not ok then
    return
end

packer.startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'feline-nvim/feline.nvim'
    use 'sheerun/vim-polyglot'
    use 'akinsho/bufferline.nvim'
    use 'NLKNguyen/papercolor-theme'
    use 'phaazon/hop.nvim'
    use 'ajh17/VimCompletesMe'
    use 'terrortylor/nvim-comment' -- gcc to toggle comment
    use 'tpope/vim-unimpaired' -- toggles yoh, yob, yow, yos
    use 'lewis6991/gitsigns.nvim'
    use 'nvim-lua/plenary.nvim' -- dependency of telescope
    use 'nvim-telescope/telescope.nvim'
    use 'thaerkh/vim-workspace'
    use 'folke/which-key.nvim'
    use 'mbbill/undotree'
    use 'terryma/vim-expand-region'
    use 'kyazdani42/nvim-web-devicons' -- file icons
    use 'kyazdani42/nvim-tree.lua'
    use 'lukas-reineke/indent-blankline.nvim' -- show | every 4 spaces
    use 'sbdchd/neoformat'
end)

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

local global=vim.g
global.plug_shallow=1

global.neoformat_basic_format_align=1
global.neoformat_basic_format_retab=1
global.neoformat_basic_format_trim=1

local home=os.getenv("HOME")
global.workspace_create_new_tabs=0
global.workspace_session_disable_on_args=1
global.workspace_session_directory=home..'/.config/nvim/sessions/'
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
