return {
  dir = "~/Documents/nvim_plugins/reload_current_plugin_lazy.nvim",
  config = function()
    vim.keymap.set("n", "<leader>rl", "<cmd>ReloadCurrentPlugin<cr>")
  end,
}
