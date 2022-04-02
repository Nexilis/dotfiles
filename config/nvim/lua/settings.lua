local set = vim.opt
set.termguicolors = true

-- Configure LSP
-- https://github.com/neovim/nvim-lspconfig#rust_analyzer
-- nvim_lsp object
local nvim_lsp = require'lspconfig'
-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end
-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup({ on_attach=on_attach })
-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        signs = true,
        update_in_insert = true,
    })
require'nvim-web-devicons'.setup {}
require'hop'.setup()
require'nvim-tree'.setup {}
require'feline'.setup()
require'bufferline'.setup {}
require'nvim_comment'.setup()
require'gitsigns'.setup()

if vim.g.nvui then
    vim.cmd [[
        NvuiFrameless 0
        NvuiPopupMenu 1
        NvuiCmdline 1
        NvuiCmdFontSize 20
        NvuiCmdFontFamily Hack Nerd Font Mono
    ]]
    set.guifont='Hack Nerd Font Mono:h13'
end

