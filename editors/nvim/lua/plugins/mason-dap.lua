return {
  "jay-babu/mason-nvim-dap.nvim",
  dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
  config = function()
    require("mason-nvim-dap").setup({
      handlers = {
        python = function(source_name)
          local dap = require("dap")
          dap.adapters.python = {
            type = "executable",
            command = "/usr/bin/python3",
            args = {
              "-m",
              "debugpy.adapter",
            },
          }

          dap.configurations.python = {
            {
              type = "python",
              request = "launch",
              name = "Launch file",
              program = "${file}",
            },
          }
        end,

        dart = function(source_name)
          local dap = require("dap")
          dap.adapters.dart = {
            type = "executable",
            command = "flutter",
            args = { "debug-adapter" },
          }
        end,
      },
    })
  end,
}