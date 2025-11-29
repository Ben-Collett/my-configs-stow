vim.g.colors_name = "mycolorscheme"
--vim.api.nvim_set_hl(0, "@lsp.type.comment", {})
--vim.api.nvim_set_hl(0, "@lsp.type.keyword", {})

--the for loop disable lsp highlighting
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  vim.api.nvim_set_hl(0, group, {}) --decorator is annotation
end

local colors = {
  bg = "#080814", -- deep pine green
  fg = "#f8f8f2", -- soft white
  red = "#ff4d4d", -- candy red
  light_green = "#b8ffb0", -- mint green
  green = "#4fd060", -- holly green
  deep_green = "#007f5f", -- evergreen
  yellow = "#fff59d", -- candlelight yellow
  blue = "#80dfff", -- icy blue
  purple = "#dca0ff", -- frosty lavender
  cyan = "#7fffd4", -- snow aqua
  gray = "#88918a", -- pine bark gray
  pink = "#ffb3c6", -- peppermint pink
  gold = "#ffd700", -- ornament gold
  orange = "#ffb347", -- gingerbread orange
  white = "#ffffff", -- pure white
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
ts_highlight("@boolean", colors.blue)
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
