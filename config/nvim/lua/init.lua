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
set.background='dark'
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

g.mapleader=' '
g.maplocalleader=','


-- ctrl+z, ctrl+v
key.set('i', '<c-z>' ,'<c-o>:u<cr>', {silent = true})
key.set('i', '<c-v>', '<esc>:set paste<cr>a<c-r>=getreg(\'+\')<cr><esc>:set nopaste<cr>a', {silent = true})

-- delete without copying
key.set('n', 'x', '"_x')
key.set({'n', 'v'}, 'd', '"_d')
key.set('n', 'D', '"_D')

au('BufWritePost', {
  pattern = 'init.lua',
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

local packerPath = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(packerPath)) > 0 then
    packer_bootstrap = fn.system({
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        packerPath,
    })
    print 'Installing packer. If problems restart and run :PackerSync.'
end

return require('packer').startup(function(use)
    use ({'wbthomason/packer.nvim',
        config = function()
            g.plug_shallow=1
        end
    })

    use ({'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup({
                options = {
                    section_separators = { left = '', right = '' },
                    component_separators = { left = '', right = '' },
                    globalstatus = true
                }
            })
        end,
        requires = {
            'kyazdani42/nvim-web-devicons'
        }
    })

    use ({'sheerun/vim-polyglot',})

    use ({'famiu/bufdelete.nvim',}) -- delete buffers without wiping layout

    use ({'akinsho/bufferline.nvim',
        config = function()
            require('bufferline').setup()
        end,
        requires = {
            'kyazdani42/nvim-web-devicons'
        }
    })

    use ({'NLKNguyen/papercolor-theme',
        config = function()
            vim.cmd [[
                colorscheme PaperColor
            ]]
        end
    })

    use ({'phaazon/hop.nvim',
        config = function()
            require('hop').setup()
            key.set('n', 'f', ':HopWord<cr>', {silent = true})
        end
    })

    use ({'ajh17/VimCompletesMe',})

    use ({'terrortylor/nvim-comment', -- gcc to toggle comment
        config = function()
            require('nvim_comment').setup()
        end
    })

    use ({'tpope/vim-unimpaired', -- toggles yoh, yob, yow, yos
        config = function()
            -- lines moving
            key.set('n', '<a-j>', ']e', {remap = true})
            key.set('n', '<a-k>', '[e', {remap = true})
        end
    })

    use ({'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end,
        requires = {
            "nvim-lua/plenary.nvim"
        }
    })

    use ({
        'nvim-telescope/telescope.nvim',
        config = function()
            require('telescope').setup({
              pickers = {
                find_files = {
                  find_command = { 'fd', '-H', '-S', '-512k', '--type', 'f', '-E', '.cache', '-E', 'flatpak', '-E', '.rustup', '-E', '.steam', '-E', '.mozilla' }
                }
              }
            })
        end,
        requires = {
            "nvim-lua/plenary.nvim"
        }
    })

    use ({'Shatur/neovim-session-manager',
        config = function()
            local smc = require('session_manager.config')
            require('session_manager').setup({autoload_mode = smc.AutoloadMode.CurrentDir})
        end
    })

    use ({'Pocco81/AutoSave.nvim',
        config = function()
            require('autosave').setup()
        end
    })

    use ({'tenxsoydev/size-matters.nvim',
        config = function()
            if vim.g.neovide or vim.g.goneovim or vim.g.nvui or vim.g.gnvim then
                require("size-matters").setup({
                    default_mappings = false
                })
            end
        end
    })

    use ({'itchyny/vim-cursorword', })

    use ({'windwp/nvim-spectre',
        config = function()
            require('spectre').setup()
        end,
        requires = {
            "nvim-lua/plenary.nvim"
        }
    })

    use ({
        'folke/which-key.nvim',
        config = function()
            local wkey = require('which-key')
            wkey.setup()

            local keymap = {
                k = {'<cmd>bnext<cr>', 'buffer-next'},
                j = {'<cmd>bprevious<cr>', 'buffer-previous'},
                q = {'<cmd>qa!<cr>', 'quit'},
                u = {'<cmd>UndotreeToggle<cr>', 'undo-tree-toggle'},
                t = {'<cmd>NvimTreeToggle<cr>', 'file-tree-toggle'},
                l = {'<cmd>nohl<cr>', 'clear-highlight'},
                r = {'<cmd>lua require("spectre").open_visual({select_word=true})<cr>', 'search-replace'},
                o = {
                    name = '+OPTIONS',
                    r = {'<cmd>so $MYVIMRC<cr>', 'config-reload'},
                    f = {'<cmd>Neoformat<cr>', 'autoformat'},
                    s = {'<cmd>setlocal spell! spelllang=en_us<cr>', 'spellchecker-toggle'},
                    ['1'] = {'<cmd>set syn=cs<cr>', 'c#'},
                    ['2'] = {'<cmd>set syn=fs<cr>', 'f#'},
                    ['3'] = {'<cmd>set syn=js<cr>', 'js'},
                    ['4'] = {'<cmd>set syn=ts<cr>', 'ts'},
                    ['5'] = {'<cmd>set syn=json<cr>', 'json'},
                    ['6'] = {'<cmd>set syn=lua<cr>', 'lua'},
                    ['7'] = {'<cmd>set syn=sh<cr>', 'bash'},
                    ['8'] = {'<cmd>set syn=terrafrom<cr>', 'terraform'},
                    ['9'] = {'<cmd>set syn=rust<cr>', 'rust'},
                    ['0'] = {'<cmd>set syn=clojure<cr>', 'clojure'},
                },
                b = {
                    name = '+BUFFER',
                    n = {'<cmd>enew<cr>', 'new'},
                    o = {'<cmd>Telescope find_files<cr>', 'open'},
                    w = {'<cmd>w!<cr>', 'write'},
                    x = {'<cmd>Bdelete<cr>', 'close'},
                    s = {'<cmd>SessionManager load_session<cr>', 'sessions'},
                    c = {'<cmd>Telescope buffers<cr>', 'current'},
                    r = {'<cmd>Telescope oldfiles<cr>', 'recent'},
                },
                h = {
                    name = '+HOP',
                    f = {'<cmd>HopWord<cr>', 'word'},
                    l = {'<cmd>HopLine<cr>', 'line'},
                    s = {'<cmd>HopChar1<cr>', 'single-char'},
                    t = {'<cmd>HopChar2<cr>', 'two-chars'},
                },
                s = {
                    name = '+SEARCH',
                    b = {'<cmd>Telescope current_buffer_fuzzy_find<cr>', 'buffer (fuzzy)'},
                    e = {'<cmd>Telescope live_grep<cr>', 'everywhere (grep)'},
                    h = {'<cmd>Telescope help_tags<cr>', 'help'},
                    c = {'<cmd>Telescope command_history<cr>', 'commands'},
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
                f = {
                    name = '+FONT',
                    ['='] = {'<cmd>FontSizeUp 2<cr>', 'size-up'},
                    ['-'] = {'<cmd>FontSizeDown 2<cr>', 'size-down'},
                    ['0'] = {'<cmd>FontReset<cr>', 'reset'},
                },
            }
            wkey.register(keymap, { prefix = "<leader>" })
        end
    })

    use ({'mbbill/undotree',
        config = function()
            g.undotree_WindowLayout=2
            g.undotree_SetFocusWhenToggle=1
        end
    })

    use ({'terryma/vim-expand-region',
        config = function()
            key.set('', '+', '<Plug>(expand_region_expand)')
            key.set('', '_', '<Plug>(expand_region_shrink)')
        end
    })

    use ({'stevearc/dressing.nvim', -- better default picker (used by neovim-session-manager)
        config = function()
            require('dressing').setup({})
        end
    })

    use ({'dstein64/nvim-scrollview',}) -- scrollbar

    use ({'kyazdani42/nvim-tree.lua',
        config = function()
            local nt = require('nvim-tree')
            nt.setup({
                renderer = { highlight_opened_files = "all" },
                update_focused_file = { enable = true },
                view = {
                    adaptive_size = true,
                }
            })
            au('SessionLoadPost', {
              callback = function() nt.toggle(false, true) end,
            })
        end,
        requires = {
            'kyazdani42/nvim-web-devicons'
        }
    })

    use ({'lukas-reineke/indent-blankline.nvim', -- show | every 4 spaces
        config = function()
            require('indent_blankline').setup()
        end
    })

    use ({'sbdchd/neoformat',
        config = function()
            g.neoformat_basic_format_align=1
            g.neoformat_basic_format_retab=1
            g.neoformat_basic_format_trim=1
        end
    })

    if packer_bootstrap then
        require('packer').sync()
    end
end)

