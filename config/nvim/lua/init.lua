g = vim.g
set = vim.opt
fn = vim.fn
key = vim.keymap
au = vim.api.nvim_create_autocmd
home = os.getenv("HOME")

set.dir = home .. '/.local/state/nvim/swap//'
set.backupdir = home .. '/.local/state/nvim/backup//'
set.undodir = home .. '/.local/state/nvim/undo//'
set.backup = true
set.swapfile = true
set.undofile = true
set.termguicolors = true
set.encoding = 'utf-8'
set.langmenu = 'en_US.utf-8'
set.background = 'light'
set.list = true
set.listchars = { tab = '▸ ', trail = '·' }
set.mousehide = true
set.mouse = 'a'
set.wrap = true
set.backspace = '2'
set.ignorecase = true
set.smartcase = true
set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4
set.expandtab = true
set.colorcolumn = '120'
set.completeopt = 'menuone,noinsert,noselect'
set.formatoptions:remove('t')
set.path:append('**')
set.wildignore:append('*/tmp/*,*/cache/*,*.so,*.swp,*.')
set.shortmess:append('c')
set.number = true
set.timeoutlen = 500
set.clipboard = 'unnamed,unnamedplus'
set.guifont = 'Hack Nerd Font Mono:h14' -- overwritten by fontsize.nvim plugin
set.inccommand = 'split'                -- show live preview of search-replace

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

g.mapleader = ' '
g.maplocalleader = ','

-- ctrl+z, ctrl+v
key.set('i', '<c-z>', '<c-o>:u<cr>', { silent = true })
key.set('i', '<c-v>', '<esc>:set paste<cr>a<c-r>=getreg(\'+\')<cr><esc>:set nopaste<cr>a', { silent = true })

-- delete without copying
key.set('n', 'x', '"_x')
key.set({ 'n', 'v' }, 'd', '"_d')
key.set('n', 'D', '"_D')

function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')


au({ 'BufRead', 'BufNewFile' },
    { pattern = '*.csx', callback = function() vim.bo.filetype = 'cs' end })

au('TextYankPost', {
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
    end
})

vim.cmd([[
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
]])

local function bootstrap_lazy()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git", "clone", "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
            lazypath
        })
    end
    vim.opt.rtp:prepend(lazypath)
end

bootstrap_lazy()

require("lazy").setup({
    'neovim/nvim-lspconfig',
    'simrat39/rust-tools.nvim',
    'ionide/Ionide-vim',
    'github/copilot.vim',
    'famiu/bufdelete.nvim',     -- delete buffers without wiping layout
    'dstein64/nvim-scrollview', -- scrollbar
    'vim-scripts/VimCompletesMe',
    'RRethy/vim-illuminate',
    {
        'roobert/search-replace.nvim',
        opts = {}
    },
    {
        'nvim-lualine/lualine.nvim',
        opts = {
            options = {
                section_separators = { left = '', right = '' },
                component_separators = { left = '', right = '' },
                globalstatus = true,
                theme = 'vscode'
            }
        },
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    }, {
    'akinsho/bufferline.nvim',
    opts = {},
    dependencies = { 'nvim-tree/nvim-web-devicons' }
}, {
    'Mofiqul/vscode.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
        require('vscode').setup({
            style = 'light',
            transparent = false,
            italic_comments = true,
        })
        require('vscode').load()
    end,
}, {
    'folke/flash.nvim', -- improved movements
    event = "VeryLazy",
    opts = {},
    keys = {
        {
            "s",
            mode = { "n", "x", "o" },
            function() require("flash").jump() end,
            desc = "Flash"
        }, {
        "S",
        mode = { "n", "x", "o" },
        function() require("flash").treesitter() end,
        desc = "Flash Treesitter"
    }, {
        "r",
        mode = "o",
        function() require("flash").remote() end,
        desc = "Remote Flash"
    }, {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc = "Treesitter Search"
    }, {
        "<c-s>",
        mode = { "c" },
        function() require("flash").toggle() end,
        desc = "Toggle Flash Search"
    }
    }
}, {
    'numToStr/Comment.nvim', -- gcc to toggle line comment, gbb to toggle block comment
    opts = {},
    lazy = false
}, {
    'tpope/vim-unimpaired', -- toggles yoh, yob, yow, yos
    config = function()
        -- lines moving
        key.set('n', '<c-j>', ']e', { remap = true })
        key.set('n', '<c-k>', '[e', { remap = true })
    end
}, {
    'lewis6991/gitsigns.nvim',
    config = function() require('gitsigns').setup() end,
    dependencies = { "nvim-lua/plenary.nvim" }
}, {
    'nvim-telescope/telescope-fzf-native.nvim',
    build =
    'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
}, {
    'nvim-telescope/telescope.nvim',
    config = function()
        local telescope = require('telescope')
        telescope.setup({
            pickers = {
                find_files = {
                    find_command = {
                        'fd', '-H', '-S', '-512k', '--type', 'f', '-E',
                        '.cache', '-E', 'flatpak', '-E', '.rustup', '-E',
                        '.steam', '-E', '.mozilla', '-E', '.m2', '-E', '.git', '-E', '.vscode'
                    }
                }
            }
        })
        telescope.load_extension('fzf')
    end,
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim", 'nvim-telescope/telescope-fzf-native.nvim' }
}, {
    'Shatur/neovim-session-manager',
    config = function()
        local smc = require('session_manager.config')
        require('session_manager').setup({
            autoload_mode = smc.AutoloadMode.CurrentDir
        })
    end,
    dependencies = {
        'stevearc/dressing.nvim'
    }
}, {
    'Sup3Legacy/fontsize.nvim',
    config = function()
        require('fontsize').init({
            -- Required argument
            font = "Hack Nerd Font Mono",
            -- Optional arguments
            min = 6,
            default = 14,
            max = 22,
            step = 4
        })
    end
}, {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {}
}, {
    'folke/which-key.nvim',
    config = function()
        local wkey = require('which-key')
        local keymap = {
            { "<leader>b", group = "BUFFER" },
            { "<leader>bc", "<cmd>Telescope buffers<cr>", desc = "current" },
            { "<leader>bf", "<cmd>Telescope find_files<cr>", desc = "find-file" },
            { "<leader>bn", "<cmd>enew<cr>", desc = "new" },
            { "<leader>bo", "<cmd>NvimTreeToggle<cr>", desc = "open" },
            { "<leader>br", "<cmd>Telescope oldfiles<cr>", desc = "recent" },
            { "<leader>bs", "<cmd>SessionManager load_session<cr>", desc = "sessions" },
            { "<leader>bw", "<cmd>w!<cr>", desc = "write" },
            { "<leader>bx", "<cmd>Bdelete<cr>", desc = "close" },
            { "<leader>f", group = "FONT" },
            { "<leader>f-", "<cmd>FontDecrease<cr>", desc = "size-down" },
            { "<leader>f0", "<cmd>FontReset<cr>", desc = "reset" },
            { "<leader>f=", "<cmd>FontIncrease<cr>", desc = "size-up" },
            { "<leader>j", "<cmd>bprevious<cr>", desc = "buffer-previous" },
            { "<leader>k", "<cmd>bnext<cr>", desc = "buffer-next" },
            { "<leader>l", "<cmd>nohl<cr>", desc = "clear-highlight" },
            { "<leader>o", group = "OPTIONS" },
            { "<leader>o0", "<cmd>set syn=clojure<cr>", desc = "clojure" },
            { "<leader>o1", "<cmd>set syn=cs<cr>", desc = "c#" },
            { "<leader>o2", "<cmd>set syn=fs<cr>", desc = "f#" },
            { "<leader>o3", "<cmd>set syn=js<cr>", desc = "js" },
            { "<leader>o4", "<cmd>set syn=ts<cr>", desc = "ts" },
            { "<leader>o5", "<cmd>set syn=json<cr>", desc = "json" },
            { "<leader>o6", "<cmd>set syn=lua<cr>", desc = "lua" },
            { "<leader>o7", "<cmd>set syn=sh<cr>", desc = "bash" },
            { "<leader>o8", "<cmd>set syn=terrafrom<cr>", desc = "terraform" },
            { "<leader>o9", "<cmd>set syn=rust<cr>", desc = "rust" },
            { "<leader>or", "<cmd>so $MYVIMRC<cr>", desc = "config-reload" },
            { "<leader>os", "<cmd>setlocal spell! spelllang=en_us<cr>", desc = "spellchecker-toggle" },
            { "<leader>q", "<cmd>qa!<cr>", desc = "quit" },
            { "<leader>r", "<cmd>SearchReplaceSingleBufferOpen<cr>", desc = "search-replace" },
            { "<leader>s", group = "SEARCH" },
            { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "buffer (fuzzy)" },
            { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "commands" },
            { "<leader>se", "<cmd>Telescope live_grep<cr>", desc = "everywhere (grep)" },
            { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "help" },
            { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "terminal-toggle" },
            { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "undo-tree-toggle" },
            { "<leader>w", group = "WINDOW" },
            { "<leader>wh", "<c-w>h", desc = "focus-left" },
            { "<leader>wj", "<c-w>j", desc = "focus-down" },
            { "<leader>wk", "<c-w>k", desc = "focus-up" },
            { "<leader>wl", "<c-w>l", desc = "focus-right" },
            { "<leader>wo", "<cmd>only<cr>", desc = "only-current-window" },
            { "<leader>wq", "<c-w>q", desc = "close" },
            { "<leader>ws", "<cmd>split<cr>", desc = "split-horizontal" },
            { "<leader>wv", "<cmd>vsplit<cr>", desc = "split-vertical" },
        }
        wkey.add(keymap)
    end
}, {
    'mbbill/undotree',
    config = function()
        g.undotree_WindowLayout = 4
        g.undotree_SetFocusWhenToggle = 1
    end
}, {
    'terryma/vim-expand-region',
    config = function()
        key.set('', '+', '<Plug>(expand_region_expand)')
        key.set('', '_', '<Plug>(expand_region_shrink)')
    end
}, {
    'nvim-tree/nvim-tree.lua',
    config = function()
        local HEIGHT_RATIO = 0.8
        local WIDTH_RATIO = 0.8

        require('nvim-tree').setup({
            view = {
                float = {
                    enable = true,
                    open_win_config = function()
                        local screen_w = vim.opt.columns:get()
                        local screen_h =
                            vim.opt.lines:get() - vim.opt.cmdheight:get()
                        local window_w = screen_w * WIDTH_RATIO
                        local window_h = screen_h * HEIGHT_RATIO
                        local window_w_int = math.floor(window_w)
                        local window_h_int = math.floor(window_h)
                        local center_x = (screen_w - window_w) / 2
                        local center_y =
                            ((vim.opt.lines:get() - window_h) / 2) -
                            vim.opt.cmdheight:get()
                        return {
                            border = 'rounded',
                            relative = 'editor',
                            row = center_y,
                            col = center_x,
                            width = window_w_int,
                            height = window_h_int
                        }
                    end
                },
                width = function()
                    return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
                end
            },
            update_focused_file = { enable = true }
        })
    end,
    event = "VeryLazy",
    dependencies = { 'nvim-tree/nvim-web-devicons' }
}, {
    'lukas-reineke/indent-blankline.nvim', -- This plugin adds indentation guides
    event = "VeryLazy",
    config = function()
        local highlight = {
            "CursorColumn",
            "Whitespace"
        }
        require("ibl").setup({
            indent = { highlight = highlight, char = "" },
            whitespace = {
                highlight = highlight,
                remove_blankline_trail = false,
            },
            scope = { enabled = false },
        })
    end
}, {
    'folke/noice.nvim',
    --event = 'VeryLazy',
    opts = {
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        -- you can enable a preset for easier configuration
        presets = {
            bottom_search = false,        -- use a classic bottom cmdline for search
            command_palette = true,       -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false,           -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false,       -- add a border to hover docs and signature help
        }
    },
    dependencies = {
        'MunifTanjim/nui.nvim', -- UI Component Library for Neovim, e.g. Layout, Popup, Input, etc.
        'rcarriga/nvim-notify'  -- A fancy, configurable, notification manager for NeoVim

    }
}
})
