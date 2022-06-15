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
    use 'Shatur/neovim-session-manager'
    use 'Pocco81/AutoSave.nvim'
    use 'folke/which-key.nvim'
    use 'mbbill/undotree'
    use 'terryma/vim-expand-region'
    use 'stevearc/dressing.nvim' -- better default picker (used by neovim-session-manager)
    use 'dstein64/nvim-scrollview' -- scrollbar
    use 'kyazdani42/nvim-web-devicons' -- file icons
    use 'kyazdani42/nvim-tree.lua'
    use 'lukas-reineke/indent-blankline.nvim' -- show | every 4 spaces
    use 'sbdchd/neoformat'
end)

local wkey = require('which-key')
wkey.setup()
require('nvim-web-devicons').setup()
require('hop').setup()
local nt = require('nvim-tree')
nt.setup({ renderer = { highlight_opened_files = "all" }, update_focused_file = { enable = true } })
require('feline').setup()
require('bufferline').setup()
require('nvim_comment').setup()
require('gitsigns').setup()
require('indent_blankline').setup()
require('autosave').setup()
local smc = require('session_manager.config')
require('session_manager').setup({autoload_mode = smc.AutoloadMode.CurrentDir})
require('dressing').setup({})

au('SessionLoadPost', {
  callback = function() nt.toggle(false, true) end,
})

vim.cmd [[
    colorscheme PaperColor
]]

g.plug_shallow=1

g.neoformat_basic_format_align=1
g.neoformat_basic_format_retab=1
g.neoformat_basic_format_trim=1

g.undotree_WindowLayout=2
g.undotree_SetFocusWhenToggle=1

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
        s = {'<cmd>setlocal spell! spelllang=en_us<cr>', 'spellchecker-toggle'},
    },
    b = {
        name = '+BUFFER',
        n = {'<cmd>enew<cr>', 'new'},
        o = {'<cmd>Telescope find_files find_command=fd prompt_prefix=🔍<cr>', 'open'},
        w = {'<cmd>w!<cr>', 'write'},
        x = {'<cmd>bp <bar> bd! #<cr>', 'close'},
        s = {'<cmd>SessionManager load_session<cr>', 'sessions'},
        l = {'<cmd>Telescope buffers<cr>', 'list'},
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
        s = {'<cmd>Telescope current_buffer_fuzzy_find<cr>', 'fuzzy-current-buffer'},
        g = {'<cmd>Telescope live_grep<cr>', 'grep-everywhere'},
        h = {'<cmd>Telescope help_tags<cr>', 'help'},
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
wkey.register(keymap, { prefix = "<leader>" })
