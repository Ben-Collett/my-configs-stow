return {
  "jay-babu/mason-nvim-dap.nvim",
  dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
  config = function()
    require("mason").setup()
  end,
  opts = {
    auto_update = true,
    run_on_start = true,
    start_delay = 300,
    debounce_hours = 24,
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
            program = "${file}", -- This configuration will launch the current file if used.
          },
        }
      end,

      dart = function(source_name)
        local dap = require("dap")
        dap.adapters.python = {
          type = "executable",
          command = "/usr/bin/python3",
          args = {
            "-m",
            "debugpy.adapter",
          },
        }
      end,
    },
  },
}
