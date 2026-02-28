return {
  "brenoprata10/nvim-highlight-colors",
  config = function()
    local hi = require("nvim-highlight-colors")
    hi.setup({
      render = "virtual",
    })
    hi.turnOn()
    vim.keymap.set({ "n", "v" }, "<leader>ch", hi.toggle)
  end,
}
