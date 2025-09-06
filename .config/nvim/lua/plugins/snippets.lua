local function define_auto_snippet(language, trig, content, args, ls, s, fmt)
  ls.add_snippets(language, { s({ trig = trig, snippetType = "autosnippet", wordTrig = true }, fmt(content, args)) })
end

local function define_manual_snippet(language, trig, content, args, ls, s, fmt)
  ls.add_snippets(language, { s(trig, fmt(content, args)) })
end

function lua(ls, s, t, i, fmt, rep)
  local lua = "lua"
end
local function python(ls, s, t, i, fmt, rep)
  local content = [[
      def __init__(self):
          {}
      ]]
  define_auto_snippet("python", "init", content, { i(1, "pass") }, ls, s, fmt)
end

function dart(ls, s, i, fmt, rep)
  local content = [[
  class {}{{
    {}._privateConstructor();
    static final {} _internal = {}._privateConstructor();
    factory {}()=> _internal;
    }}]]
  local args = { i(1), rep(1), rep(1), rep(1), rep(1) }

  define_manual_snippet("dart", "si", content, args, ls, s, fmt)

  args = { i(1, "returnType"), i(2, "funcName"), i(3, "parameters"), i(4) }
  content = [[{} {}({}) => {};]]

  define_manual_snippet("dart", "inf", content, args, ls, s, fmt)

  args = { i(1, "void"), i(2, "funcName"), i(3), i(4) }
  content = [[
        {} {}({}){{
          {}
        }}
      ]]

  define_auto_snippet("dart", "MAKE_FUNCTION_PLZ ", content, args, ls, s, fmt)

  args = { i(1, "ClassName"), i(2) }
  content = [[
        class {}{{
          {}
        }}
      ]]

  define_auto_snippet("dart", "DECLARE_CLASS_PLZ ", content, args, ls, s, fmt)

  args = { i(1) }
  content = "print({});"
  define_auto_snippet("dart", "PRINT_PLZ ", content, args, ls, s, fmt)
end

function java(ls, s, t, i, fmt, rep)
  ls.add_snippets("java", {
    s(
      "test",
      fmt(
        [[
  @Test
  public void {} {{
      {}
  }}]],
        i(1),
        i(2)
      )
    ),
  })
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
    skey = vim.keymap.set
    skey({ "i", "v" }, "<C-L>", function()
      ls.jump(1)
    end)
    skey({ "i", "v" }, "<C-H>", function()
      ls.jump(-1)
    end)
    lua(ls, s, t, i, fmt, rep)
    dart(ls, s, i, fmt, rep)
    python(ls, s, t, i, fmt, rep)
    vim.keymap.set({ "v", "n" }, "<leader>wi", function()
      --local selected = selected()
      --vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":'<,'>delete<CR>i", true, false, true), "n", false)
      ls.expand() -- I think this will work as long as I type the text first a cursor is at write spot
    end)
  end,
}
