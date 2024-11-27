return  {
  'mfussenegger/nvim-dap',
  dependencies = {"rcarriga/nvim-dap-ui",'theHamsta/nvim-dap-virtual-text',"nvim-neotest/nvim-nio"},
  config = function ()
      local kmap = vim.keymap
      local nio = require('nio') -- dapui requires nio
      local dap, dapui,vtext = require("dap"), require("dapui"), require("nvim-dap-virtual-text")
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
    kmap.set('n', '<Leader>b',dap.toggle_breakpoint)
    kmap.set('n', '<Leader>dc',dap.continue)
    kmap.set('n','<Leader>dso',dap.step_over)
    kmap.set('n','<Leader>dou',dap.step_out)
    kmap.set('n','<Leader>dsb',dap.step_back)
    kmap.set('n','<Leader>dcu',dap.run_to_cursor)
  end

}
