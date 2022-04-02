local set = vim.opt
set.termguicolors = true
set.list = true
set.listchars:append('space:⋅')

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

require'nvim-web-devicons'.setup {}
require'hop'.setup()
require'nvim-tree'.setup {}
require'feline'.setup()
require'bufferline'.setup {}
require'nvim_comment'.setup()
require'gitsigns'.setup()
require'indent_blankline'.setup {}
