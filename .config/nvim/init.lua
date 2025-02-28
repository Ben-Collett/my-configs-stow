vim.opt.undofile = true
require("config.keymaps")
require("config.lazy")
require("config.style")
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if #vim.fn.argv() == 0 then -- Only trigger if no file is specified
      vim.cmd("Telescope oldfiles")
    end
  end,
})
