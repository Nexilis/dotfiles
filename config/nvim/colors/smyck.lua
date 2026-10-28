-- Smyck, built from the palette of Ghostty's "Smyck" theme so nvim and the
-- terminal share colors. Treesitter and LSP captures need no entries here:
-- nvim links them to the standard groups by default.

vim.cmd("highlight clear")
vim.o.background = "dark"
vim.g.colors_name = "smyck"

local c = {
  bg = "#1b1b1b",
  bg_alt = "#262626",
  bg_float = "#2a2a2a",
  fg = "#f7f7f7",
  gray = "#a1a1a1",
  comment = "#8f8f8f",
  dim = "#5e5e5e",
  red = "#b84131",
  red_br = "#d6837c",
  green = "#7da900",
  green_br = "#c4f137",
  yellow = "#c4a500",
  yellow_br = "#fee14d",
  blue = "#62a3c4",
  blue_br = "#8dcff0",
  magenta = "#ba8acc",
  magenta_br = "#f79aff",
  cyan = "#207383",
  cyan_br = "#6ad9cf",
  selection = "#207483",
}

local groups = {
  Normal = { fg = c.fg, bg = c.bg },
  NormalFloat = { fg = c.fg, bg = c.bg_float },
  FloatBorder = { fg = c.dim, bg = c.bg_float },
  Cursor = { fg = c.bg, bg = "#bbbbbb" },
  CursorLine = { bg = c.bg_alt },
  CursorColumn = { bg = c.bg_alt },
  ColorColumn = { bg = c.bg_alt },
  LineNr = { fg = c.dim },
  CursorLineNr = { fg = c.yellow_br, bold = true },
  SignColumn = { bg = c.bg },
  VertSplit = { fg = c.dim },
  WinSeparator = { fg = c.dim },
  StatusLine = { fg = c.fg, bg = c.bg_float },
  StatusLineNC = { fg = c.comment, bg = c.bg_alt },
  TabLine = { fg = c.comment, bg = c.bg_alt },
  TabLineSel = { fg = c.fg, bg = c.bg },
  TabLineFill = { bg = c.bg_alt },
  Visual = { fg = c.fg, bg = c.selection },
  Search = { fg = c.bg, bg = c.yellow_br },
  IncSearch = { fg = c.bg, bg = c.green_br },
  CurSearch = { link = "IncSearch" },
  MatchParen = { fg = c.yellow_br, bold = true, underline = true },
  Pmenu = { fg = c.fg, bg = c.bg_float },
  PmenuSel = { fg = c.fg, bg = c.selection },
  PmenuSbar = { bg = c.bg_alt },
  PmenuThumb = { bg = c.dim },
  NonText = { fg = c.dim },
  Whitespace = { fg = c.dim },
  SpecialKey = { fg = c.dim },
  Folded = { fg = c.comment, bg = c.bg_alt },
  FoldColumn = { fg = c.dim },
  Title = { fg = c.blue_br, bold = true },
  Directory = { fg = c.blue_br },
  ErrorMsg = { fg = c.red_br, bold = true },
  WarningMsg = { fg = c.yellow_br },
  MoreMsg = { fg = c.green },
  Question = { fg = c.green },
  ModeMsg = { fg = c.fg, bold = true },

  Comment = { fg = c.comment, italic = true },
  Constant = { fg = c.yellow },
  String = { fg = c.green },
  Character = { fg = c.green },
  Number = { fg = c.yellow },
  Boolean = { fg = c.yellow },
  Float = { fg = c.yellow },
  Identifier = { fg = c.fg },
  Function = { fg = c.blue_br },
  Statement = { fg = c.blue },
  Keyword = { fg = c.blue },
  Conditional = { fg = c.blue },
  Repeat = { fg = c.blue },
  Operator = { fg = c.gray },
  Exception = { fg = c.red_br },
  PreProc = { fg = c.red_br },
  Include = { fg = c.red_br },
  Type = { fg = c.magenta },
  StorageClass = { fg = c.magenta },
  Structure = { fg = c.magenta },
  Special = { fg = c.cyan_br },
  Delimiter = { fg = c.gray },
  Underlined = { underline = true },
  Error = { fg = c.red_br },
  Todo = { fg = c.bg, bg = c.yellow_br, bold = true },

  DiffAdd = { bg = "#2b3a10" },
  DiffChange = { bg = "#1d2f38" },
  DiffDelete = { fg = c.red_br, bg = "#3a1d1a" },
  DiffText = { bg = "#2c4c5c" },
  Added = { fg = c.green },
  Changed = { fg = c.blue },
  Removed = { fg = c.red_br },

  DiagnosticError = { fg = c.red_br },
  DiagnosticWarn = { fg = c.yellow_br },
  DiagnosticInfo = { fg = c.blue_br },
  DiagnosticHint = { fg = c.cyan_br },
  DiagnosticOk = { fg = c.green },
  DiagnosticUnderlineError = { undercurl = true, sp = c.red_br },
  DiagnosticUnderlineWarn = { undercurl = true, sp = c.yellow_br },
  DiagnosticUnderlineInfo = { undercurl = true, sp = c.blue_br },
  DiagnosticUnderlineHint = { undercurl = true, sp = c.cyan_br },
  SpellBad = { undercurl = true, sp = c.red_br },
  SpellCap = { undercurl = true, sp = c.yellow_br },
}

for name, spec in pairs(groups) do
  vim.api.nvim_set_hl(0, name, spec)
end

-- :terminal buffers get the same 16 colors as Ghostty.
local ansi = {
  "#000000", c.red, c.green, c.yellow, c.blue, c.magenta, c.cyan, c.gray,
  "#7a7a7a", c.red_br, c.green_br, c.yellow_br, c.blue_br, c.magenta_br, c.cyan_br, c.fg,
}
for i, color in ipairs(ansi) do
  vim.g["terminal_color_" .. (i - 1)] = color
end
