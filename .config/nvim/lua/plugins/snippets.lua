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
    require("my_snippets").set_up_snippets(ls, s, t, i, fmt, rep)
    vim.keymap.set({ "v", "n" }, "<leader>wi", function()
      --local selected = selected()
      --vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":'<,'>delete<CR>i", true, false, true), "n", false)
      ls.expand() -- I think this will work as long as I type the text first a cursor is at write spot
    end)
  end,
}
