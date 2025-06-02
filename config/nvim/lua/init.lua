g = vim.g
set = vim.opt
fn = vim.fn
key = vim.keymap
au = vim.api.nvim_create_autocmd
cmd = vim.cmd
home = os.getenv("HOME")

if g.neovide then
  g.neovide_position_animation_length = 0
  g.neovide_scroll_animation_length = 0
  g.neovide_scroll_animation_far_lines = 0
  g.neovide_hide_mouse_when_typing = false
end

set.dir = home .. "/.local/state/nvim/swap//"
set.backupdir = home .. "/.local/state/nvim/backup//"
set.undodir = home .. "/.local/state/nvim/undo//"
set.backup = true
set.swapfile = true
set.undofile = true
set.termguicolors = true
set.encoding = "utf-8"
set.langmenu = "en_US.utf-8"
set.background = "light"
set.list = true
set.listchars = { tab = "▸ ", trail = "·" }
set.mousehide = true
set.mouse = "a"
set.wrap = true
set.backspace = "2"
set.ignorecase = true
set.smartcase = true
set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = 2
set.expandtab = true
set.colorcolumn = "120"
set.completeopt = "menuone,noinsert,noselect"
set.formatoptions:remove("t")
set.path:append("**")
set.wildignore:append("*/tmp/*,*/cache/*,*.so,*.swp,*.")
set.shortmess:append("c")
set.number = true
set.timeoutlen = 500
set.clipboard = "unnamed,unnamedplus"
set.guifont = "Hack Nerd Font Mono:h14" -- overwritten by fontsize.nvim plugin
set.inccommand = "split" -- show live preview of search-replace

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

g.mapleader = " "
g.maplocalleader = ","

-- ctrl+z, ctrl+v
key.set("i", "<c-z>", "<c-o>:u<cr>", { silent = true })
key.set("i", "<c-v>", "<esc>:set paste<cr>a<c-r>=getreg('+')<cr><esc>:set nopaste<cr>a", { silent = true })

-- command+z, command+v
key.set("i", "<D-z>", "<c-o>:u<cr>", { silent = true })
key.set("i", "<D-v>", "<esc>:set paste<cr>a<c-r>=getreg('+')<cr><esc>:set nopaste<cr>a", { silent = true })

-- delete without copying
key.set("n", "x", '"_x')
key.set({ "n", "v" }, "d", '"_d')
key.set("n", "D", '"_D')

-- copilot
key.set("i", "<D-s>", "<cmd>lua require('copilot.suggestion').accept_word()<cr>", { silent = true })
key.set("i", "<D-d>", "<cmd>lua require('copilot.suggestion').accept_line()<cr>", { silent = true })
key.set("i", "<D-]>", "<cmd>lua require('copilot.suggestion').next()<cr>", { silent = true })
key.set("i", "<D-[>", "<cmd>lua require('copilot.suggestion').prev()<cr>", { silent = true })

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  key.set("t", "<esc>", [[<C-\><C-n>]], opts)
  key.set("t", "jk", [[<C-\><C-n>]], opts)
  key.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  key.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  key.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  key.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  key.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- auto enable LSP for all available configs, based on neovim's 0.11 capabilities
local configs = {}
for _, v in ipairs(vim.api.nvim_get_runtime_file("lsp/*", true)) do
  local name = fn.fnamemodify(v, ":t:r")
  configs[name] = true
end
vim.lsp.enable(vim.tbl_keys(configs))

au({ "BufRead", "BufNewFile" }, {
  pattern = "*.csx",
  callback = function()
    vim.bo.filetype = "cs"
  end,
})

au("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

au("User", {
  pattern = "BlinkCmpMenuOpen",
  callback = function()
    vim.b.copilot_suggestion_hidden = true
  end,
})

au("User", {
  pattern = "BlinkCmpMenuClose",
  callback = function()
    vim.b.copilot_suggestion_hidden = false
  end,
})

cmd([[
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
]])

local function bootstrap_lazy()
  local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

bootstrap_lazy()

require("lazy").setup({
  "rebelot/kanagawa.nvim", -- colorscheme
  "Mofiqul/vscode.nvim", -- colorscheme
  {
    -- Once copilot is running, run `:Copilot auth` to start the authentication process.
    "zbirenbaum/copilot.lua", -- github copilot
    opts = {
      suggestion = {
        auto_trigger = true,
      },
      filetypes = {
        markdown = true,
        ["."] = false,
      },
    },
  },
  {
    "williamboman/mason.nvim", -- package manager, install LSP servers, linters, formatters
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim", -- bridges mason and lspconfig
    opts = {
      ensure_installed = {
        "denols",
        "fsautocomplete",
        "lua_ls",
        "rust_analyzer",
      },
    },
  },
  "neovim/nvim-lspconfig", -- enable LSP
  {
    "nvim-treesitter/nvim-treesitter", -- syntax highlighting
    build = ":TSUpdate",
    opts = {
      auto_install = true,
      ensure_installed = {
        "bash",
        "css",
        "c_sharp",
        "dockerfile",
        "fish",
        "fsharp",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "python",
        "rust",
        "typescript",
        "yaml",
      },
      highlight = {
        enable = true,
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    config = true,
    strategies = {
      chat = {
        adapter = "copilot",
      },
      inline = {
        adapter = "copilot",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "claude-3.7-sonnet",
              },
            },
          })
        end,
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            url = "http://localhost:11434", -- Adjust if you're using a different URL
            schema = {
              model = {
                default = "gemma3:12b",
              },
            },
          })
        end,
      },
    },
  },

  "famiu/bufdelete.nvim", -- delete buffers without wiping layout
  "dstein64/nvim-scrollview", -- scrollbar
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = { "rafamadriz/friendly-snippets" },

    -- use a release tag to download pre-built binaries
    version = "1.*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = "enter" },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },
      -- (Default) Only show the documentation popup when manually triggered
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        menu = {
          -- Don't automatically show the completion menu
          auto_show = false,

          -- nvim-cmp style menu
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" },
            },
          },
        },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path" }, --  ,"snippets", "buffer" },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
  {
    "echasnovski/mini.cursorword", -- underline all instances of the word under the cursor
    opts = {},
  },
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      update_interval = 3000,
      set_dark_mode = function()
        set.background = "dark"
        cmd("colorscheme vscode")
      end,
      set_light_mode = function()
        set.background = "light"
        cmd("colorscheme vscode")
      end,
    },
  },
  {
    "roobert/search-replace.nvim",
    opts = {},
  },
  {
    "nvim-lualine/lualine.nvim", -- statusline
    opts = {
      options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        globalstatus = true,
        theme = "vscode",
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "romgrk/barbar.nvim", -- top bar
    dependencies = {
      "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
      "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {},
  },
  {
    "folke/flash.nvim", -- improved movements
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
  {
    "numToStr/Comment.nvim", -- gcc to toggle line comment, gbb to toggle block comment
    opts = {},
    lazy = false,
  },
  {
    "tpope/vim-unimpaired", -- toggles yoh, yob, yow, yos
    config = function()
      -- lines moving
      key.set("n", "<c-j>", "]e", { remap = true })
      key.set("n", "<c-k>", "[e", { remap = true })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  { "natecraddock/telescope-zf-native.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        pickers = {
          find_files = {
            find_command = {
              "fd",
              "-H",
              "-S",
              "-512k",
              "--type",
              "f",
              "-E",
              ".cache",
              "-E",
              "flatpak",
              "-E",
              ".rustup",
              "-E",
              ".steam",
              "-E",
              ".mozilla",
              "-E",
              ".m2",
              "-E",
              ".git",
              "-E",
              ".vscode",
            },
          },
        },
      })
      telescope.load_extension("zf-native")
    end,
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim", "natecraddock/telescope-zf-native.nvim" },
  },
  {
    "Shatur/neovim-session-manager",
    config = function()
      local smc = require("session_manager.config")
      require("session_manager").setup({
        autoload_mode = smc.AutoloadMode.CurrentDir,
      })
    end,
    dependencies = {
      "stevearc/dressing.nvim",
    },
  },
  {
    "Sup3Legacy/fontsize.nvim",
    config = function()
      require("fontsize").init({
        -- Required argument
        font = "Hack Nerd Font Mono",
        -- Optional arguments
        min = 6,
        default = 14,
        max = 22,
        step = 4,
      })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {},
  },
  {
    "folke/which-key.nvim",
    config = function()
      local wkey = require("which-key")
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
        { "<leader>c", group = "CODE" },
        { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", desc = "chat" },
        { "<leader>ca", "<cmd>CodeCompanionActions<cr>", desc = "actions" },
        { "<leader>f", group = "FONT" },
        { "<leader>f-", "<cmd>FontDecrease<cr>", desc = "size-down" },
        { "<leader>f0", "<cmd>FontReset<cr>", desc = "reset" },
        { "<leader>f=", "<cmd>FontIncrease<cr>", desc = "size-up" },
        { "<leader>j", "<cmd>bprevious<cr>", desc = "buffer-previous" },
        { "<leader>k", "<cmd>bnext<cr>", desc = "buffer-next" },
        { "<leader>l", "<cmd>nohl<cr>", desc = "clear-highlight" },
        { "<leader>o", group = "OPTIONS" },
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
    end,
  },
  {
    "mbbill/undotree",
    config = function()
      g.undotree_WindowLayout = 4
      g.undotree_SetFocusWhenToggle = 1
    end,
  },
  {
    "terryma/vim-expand-region",
    config = function()
      key.set("", "+", "<Plug>(expand_region_expand)")
      key.set("", "_", "<Plug>(expand_region_shrink)")
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      local HEIGHT_RATIO = 0.8
      local WIDTH_RATIO = 0.8

      require("nvim-tree").setup({
        view = {
          float = {
            enable = true,
            open_win_config = function()
              local screen_w = vim.opt.columns:get()
              local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
              local window_w = screen_w * WIDTH_RATIO
              local window_h = screen_h * HEIGHT_RATIO
              local window_w_int = math.floor(window_w)
              local window_h_int = math.floor(window_h)
              local center_x = (screen_w - window_w) / 2
              local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
              return {
                border = "rounded",
                relative = "editor",
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
              }
            end,
          },
          width = function()
            return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
          end,
        },
        update_focused_file = { enable = true },
      })
    end,
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "folke/noice.nvim", -- plugin that completely replaces the UI for messages, cmdline and the popupmenu
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
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim", -- UI Component Library for Neovim, e.g. Layout, Popup, Input, etc.
      "rcarriga/nvim-notify", -- A fancy, configurable, notification manager for NeoVim
    },
  },
})
