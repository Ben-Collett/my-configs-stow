return {
  "mfussenegger/nvim-dap-python",
  dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("nvim-treesitter").setup()
    local dap = require("dap")
    dap.adapters.python = {
      type = "executable",
      command = "python",
      args = { "-m", "debugpy.adapter" },
      options = {
        detached = true,
      },
    }

    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file with venv",
        justMyCode = false,
        program = "${file}",
        cwd = vim.fn.getcwd(),
        pythonPath = "/usr/bin/python",
      },
    }
  end,
}
