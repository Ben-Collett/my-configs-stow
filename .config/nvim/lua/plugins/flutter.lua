return {
  "nvim-flutter/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim", -- optional for vim.ui.select
    "mfussenegger/nvim-dap",
  },
  opts = {
    widget_guides = {
      enabled = true,
    },
    debugger = { -- integrate with nvim dap + install dart code debugger
      enabled = true,
    },
  },
}
