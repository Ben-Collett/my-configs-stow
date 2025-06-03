local function selected()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2]
  local end_line = end_pos[2]

  -- buffer‐indexed at 0, and end line is exclusive
  local lines = vim.api.nvim_buf_get_lines(
    0,
    start_line - 1,
    end_line, -- this is *inclusive* of the last line number
    false -- don't strip newlines
  )
  return table.concat(lines, "\n")
end
function lua(ls, s, t, i, fmt, rep)
  local lua = "lua"
end
function python(ls, s, t, i, fmt, rep)
  ls.add_snippets("python", {
    s(
      { trig = "init", snippetType = "autosnippet", wordTrig = true },
      fmt(
        [[
      def __init__(self):
          {}
      ]],
        { i(1, "pass") }
      )
    ),
  })
end

function dart(ls, s, i, fmt, rep)
  local dart = "dart"
  ls.add_snippets(dart, {
    s(
      "si",
      fmt(
        [[
  class {}{{
    {}._privateConstructor();
    static final {} _internal = {}._privateConstructor();
    factory {}()=> _internal;
    }}]],
        { i(1), rep(1), rep(1), rep(1), rep(1) }
      )
    ),
  })
  ls.add_snippets(
    dart,
    { s("inf", fmt([[{} {}({}) => {};]], { i(1, "returnType"), i(2, "funcName"), i(3, "parameters"), i(4) })) }
  )

  ls.add_snippets(dart, {
    s(
      { trig = "MAKE_FUNCTION_PLZ ", snippetType = "autosnippet", wordTrig = true },
      fmt(
        [[
        {} {}({}){{
          {}
        }}
      ]],
        { i(1, "void"), i(2, "func_name"), i(3), i(4) }
      )
    ),
  })
  ls.add_snippets(dart, {
    s(
      { trig = "DECLARE_CLASS_PLZ ", snippetType = "autosnippet", wordTrig = true },
      fmt(
        [[
        class {}{{
          {}
        }}
      ]],
        { i(1, "ClassName"), i(2) }
      )
    ),
  })
  ls.add_snippets(dart, {
    s(
      { trig = "PRINT_PLZ ", snippetType = "autosnippet", wordTrig = true },
      fmt(
        [[
        print({})
        ]],
        { i(1) }
      )
    ),
  })
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
