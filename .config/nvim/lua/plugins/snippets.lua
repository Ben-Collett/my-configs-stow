function lua(ls, s, t, i, fmt, rep)
  local lua = "lua"
  ls.add_snippets(lua, {
    s(
      "sn",
      fmt(
        [=[
      ls.add_snippets({}, {{s("{}",fmt([[{}]],{}))}})
    ]=],
        { i(1), i(2), i(3), i(4) }
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
end

return {
  "L3MON4D3/LuaSnip",
  -- follow latest release.
  version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  -- install jsregexp (optional!).
  build = "make install_jsregexp",
  config = function()
    ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local fmt = require("luasnip.extras.fmt").fmt
    local rep = require("luasnip.extras").rep

    skey = vim.keymap.set
    skey("i", "<C-L>", function()
      ls.jump(1)
    end)
    skey("i", "<C-;>", function()
      ls.jump(-1)
    end)
    lua(ls, s, t, i, fmt, rep)
    dart(ls, s, i, fmt, rep)
  end,
}
