return {
  dir = "~/Documents/nvim_plugins/easy_emphasis.nvim",
  config = function()
    local emp = require("easy_emphasis")
    emp.setup()
    vim.keymap.set({ "v", "n" }, "<leader>hl", emp.highlight)
  end,
}
