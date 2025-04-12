return {
  "mfussenegger/nvim-dap",
  dependencies = { "rcarriga/nvim-dap-ui", "theHamsta/nvim-dap-virtual-text", "nvim-neotest/nvim-nio" },
  config = function()
    local kmap = vim.keymap
    local nio = require("nio") -- dapui requires nio
    local dap, dapui, vtext = require("dap"), require("dapui"), require("nvim-dap-virtual-text")
    --local pdap = require("dap-python")
    dapui.setup()
    vtext.setup()
    --pdap.setup()
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
    kmap.set("n", "<C-b>", dap.toggle_breakpoint)
    kmap.set("n", "<C-d>", dap.continue)
    kmap.set("n", "<C-j>", dap.step_over)
    kmap.set("n", "<C-s>", dap.step_into)
    kmap.set("n", "<Leader>dou", dap.step_out)
    kmap.set("n", "<C-k>", dap.step_back)
    kmap.set("n", "<C-c>", dap.run_to_cursor)

    dap.adapters.dart = {
      type = "executable",
      command = "flutter",
      args = { "debug-adapter" },
    }

    dap.configurations.dart = {
      {
        type = "dart",
        request = "launch",
        name = "Launch file with venv",
        justMyCode = true,
        program = "${file}",
        cwd = vim.fn.getcwd(),
      },
    }
  end,
}
