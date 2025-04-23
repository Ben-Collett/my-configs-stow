vim.opt.undofile = true
vim.opt.termguicolors = true
require("config.keymaps")
require("config.lazy")
require("config.style")
vim.filetype.add({
  extension = {
    obf = "json",
  },
})
