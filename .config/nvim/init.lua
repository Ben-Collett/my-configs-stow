vim.opt.undofile = true
vim.opt.termguicolors = true
require("config.keymaps")
require("config.lazy")
--also has keymaps
require("scripts.load_scripts")

require("config.style")
vim.filetype.add({
  extension = {
    obf = "json",
  },
})
