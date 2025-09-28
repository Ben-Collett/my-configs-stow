local function define_auto_snippet(language, trig, content, args, ls, s, fmt)
  ls.add_snippets(language, { s({ trig = trig, snippetType = "autosnippet", wordTrig = true }, fmt(content, args)) })
end

local function define_manual_snippet(language, trig, content, args, ls, s, fmt)
  ls.add_snippets(language, { s(trig, fmt(content, args)) })
end
local function dart(ls, s, t, i, fmt, rep)
  local args = { i(1, "className"), i(2), i(3) }
  local content = "class {}{{\n  {}\n}}{}"
  define_auto_snippet("dart", "DECLARE_CLASS_PLZ ", content, args, ls, s, fmt)
  args = { i(1, "name"), i(2, "value"), i(3) }
  content = "final {} = {};{}"
  define_auto_snippet("dart", "immutable", content, args, ls, s, fmt)
  args = { i(1, "int"), i(2, "name"), i(3, "value") }
  content = "{} get {}=>{};"
  define_auto_snippet("dart", "getter_fat_arrow", content, args, ls, s, fmt)
  args = { i(1, "conditional"), i(2), i(3) }
  content = "if({}){{\n  {}\n}}{}"
  define_auto_snippet("dart", "if", content, args, ls, s, fmt)
  args = { i(1, "name"), i(2, "int"), i(3, "value"), i(4, "content"), i(5) }
  content = "set {}({} {}){{\n  {}\n}}{}"
  define_auto_snippet("dart", "setter", content, args, ls, s, fmt)
  args = { i(1, "void"), i(2, "name"), i(3, "params"), i(4, "content"), i(5) }
  content = "{} {}({}){{\n  {}\n  }}{}"
  define_auto_snippet("dart", "function", content, args, ls, s, fmt)
  args = { i(1, "name"), i(2, "value"), i(3) }
  content = "const {} = {};{}"
  define_auto_snippet("dart", "DECLARE_CONST_PLZ ", content, args, ls, s, fmt)
  args = { i(1, "var"), i(2, "name"), i(3, "value"), i(4) }
  content = "{} {} = {};\n{}"
  define_auto_snippet("dart", "DECLARE_VAR_PLZ ", content, args, ls, s, fmt)
  args = { i(1, "content"), i(2) }
  content = "print({});{}"
  define_auto_snippet("dart", "print", content, args, ls, s, fmt)
  args = { i(1, "content"), i(2) }
  content = "print({});{}"
  define_auto_snippet("dart", "PRINT_PLZ ", content, args, ls, s, fmt)
  args = { i(1, "void"), i(2, "name"), i(3, "params"), i(4, "content") }
  content = "{} {}({}) => {}"
  define_auto_snippet("dart", "function_short", content, args, ls, s, fmt)
  args = { i(1, "int"), i(2, "name"), i(3, "content"), i(4, "return"), i(5) }
  content = "{} get {}{{\n  {}\n  return {};\n}}{}"
  define_auto_snippet("dart", "getter", content, args, ls, s, fmt)
end
local function java(ls, s, t, i, fmt, rep)
  local args = { i(1, "toPrint") }
  local content = "System.out.println({});"
  define_manual_snippet("java", "sout", content, args, ls, s, fmt)
  args = { i(1, "toPrint") }
  content = "System.out.println({});"
  define_auto_snippet("java", "PRINT_PLZ ", content, args, ls, s, fmt)
end
local function python(ls, s, t, i, fmt, rep)
  local args = { i(1, "pass") }
  local content = "def __init__(self):\n  {}"
  define_auto_snippet("python", "init", content, args, ls, s, fmt)
end
local function set_up_snippets(ls, s, t, i, fmt, rep)
  dart(ls, s, t, i, fmt, rep)
  java(ls, s, t, i, fmt, rep)
  python(ls, s, t, i, fmt, rep)
end
return {
  "L3MON4D3/LuaSnip",
  -- follow latest release.
  version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  -- install jsregexp (optional!).
  build = "make install_jsregexp",

  config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local fmt = require("luasnip.extras.fmt").fmt
    local rep = require("luasnip.extras").rep
    ls.config.set_config({
      enable_autosnippets = true,
    })
    local skey = vim.keymap.set
    skey({ "i", "v" }, "<C-L>", function()
      ls.jump(1)
    end)
    skey({ "i", "v" }, "<C-H>", function()
      ls.jump(-1)
    end)
    set_up_snippets(ls, s, t, i, fmt, rep)
    vim.keymap.set({ "v", "n" }, "<leader>wi", function()
      --local selected = selected()
      --vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":'<,'>delete<CR>i", true, false, true), "n", false)
      ls.expand() -- I think this will work as long as I type the text first a cursor is at write spot
    end)
  end,
}
