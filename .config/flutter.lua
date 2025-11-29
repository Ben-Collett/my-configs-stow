return {
  "nvim-flutter/flutter-tools.nvim",
  lazy = false,
  lsp = {
    on_init = function(client)
      client.flags.allow_incremental_sync = false
    end,
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim", -- optional for vim.ui.select
    "mfussenegger/nvim-dap",
  },
  opts = {
    widget_guides = {
      enabled = true,
    },
  },
}
