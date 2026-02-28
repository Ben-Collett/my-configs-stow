-- ~/.config/nvim/colors/mycolorscheme.lua

vim.g.colors_name = "mycolorscheme"
--vim.api.nvim_set_hl(0, "@lsp.type.comment", {})
--vim.api.nvim_set_hl(0, "@lsp.type.keyword", {})

--the for loop disable lsp highlighting
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  vim.api.nvim_set_hl(0, group, {}) --decorator is annotation
end

local colors = {
  bg = "#110112",
  fg = "#FFFFFF",
  red = "#e06c75", -- Error/Warning (red)
  light_green = "#B7E892", --numbers
  green = "#98c379", -- Success/Highlight (green)
  deep_green = "#31A3A3",
  yellow = "#e5c07b", -- Warning (yellow)
  blue = "#61afef", -- Information (blue)
  dark_blue = "#1234E9",
  purple = "#c678dd",
  cyan = "#56b6c2",
  gray = "#a0a0a0", --comments
  pink = "#FFC0CB",
  gold = "#cfb53b",
  orange = "#dd8e04",
  white = "#ffffff",
}
local variable = 2 + 3
local bool = true

local ts_highlight = function(group, fg, bg, style)
  local cmd = "highlight " .. group .. " guifg=" .. fg
  if bg then
    cmd = cmd .. " guibg=" .. bg
  end
  if style then
    cmd = cmd .. " gui=" .. style
  end
  vim.cmd(cmd)
end
local path = "~/.config/nvim/init.lua"
ts_highlight("Normal", colors.fg, colors.bg)
ts_highlight("Statement", colors.blue, nil)
ts_highlight("Type", colors.deep_green, nil)
--TODO: test
-- Example for Tree-sitter highlight groups:
ts_highlight("@keyword", colors.red, nil)
ts_highlight("@keyword.debug", colors.red)
ts_highlight("@keyword.conditional", colors.purple, nil)
ts_highlight("@function", colors.green, nil)
ts_highlight("@number", colors.light_green)
ts_highlight("@boolean", colors.dark_blue)
ts_highlight("@constructor", colors.green, nil)
ts_highlight("@string", colors.yellow, nil)
ts_highlight("@string.special.url", colors.yellow, nil, "underline")
ts_highlight("@string.special.path", colors.yellow, nil, "underline")
ts_highlight("@variable", colors.blue, nil)
ts_highlight("@variable.builtin", colors.orange, nil)
ts_highlight("@comment.", colors.gray, nil)
ts_highlight("@comment.TODO", colors.white, nil, "underline") -- you have to TSInstall comment for this to work
ts_highlight("@attribute", colors.pink)
ts_highlight("@keyword.return", colors.gold, nil, "italic")
--ts_highlight(@variable, colors., bg, style)
