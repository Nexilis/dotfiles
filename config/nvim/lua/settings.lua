local set = vim.opt
set.termguicolors = true
set.list = true
set.listchars:append('space:⋅')

if vim.g.nvui then
    vim.cmd [[
        NvuiAnimationsEnabled 0
        NvuiFrameless 0
        NvuiPopupMenu 1
        NvuiCmdline 1
        NvuiCmdCenterYPos 1
        NvuiCmdPadding 0
        NvuiCmdBorderWidth 0
        NvuiCmdFontSize 20
        NvuiCmdBigFontScaleFactor 1.0
        NvuiCmdFontFamily Hack Nerd Font Mono
    ]]
    set.guifont='Hack Nerd Font Mono:h11'
end

require'nvim-web-devicons'.setup {}
require'hop'.setup()
require'nvim-tree'.setup {}
require'feline'.setup()
require'bufferline'.setup {}
require'nvim_comment'.setup()
require'gitsigns'.setup()
require'indent_blankline'.setup {}
