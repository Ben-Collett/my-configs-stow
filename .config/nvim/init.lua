vim.opt.undofile = true
vim.opt.termguicolors = true
require("config.keymaps")
--also has keymaps
require("scripts.load_scripts")

require("config.lazy")
require("config.style")
vim.filetype.add({
  extension = {
    obf = "json",
  },
})

local uv = vim.loop
local client = uv.new_tcp()
local connected = false

local function ensure_connected()
  if connected then
    return
  end
  client:connect("127.0.0.1", 8765, function(err)
    if err then
      client:close()
      return
    end
    connected = true
  end)
end

local function send_cb()
  ensure_connected()
  if connected then
    client:write("cb\n")
  end
end

vim.on_key(function()
  local mode = vim.api.nvim_get_mode().mode
  if mode:sub(1, 1) == "i" or mode:sub(1, 1) == "c" or mode:sub(1, 1) == "t" then
    return
  end
  send_cb()
end, vim.api.nvim_create_namespace("send_cb_on_key"))
--vim.lsp.set_log_level("debug")
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   callback = function(args)
--     if vim.fn.filereadable(args.file) == 1 then
--       @diagnostic disable-next-line: missing-fields
--       vim.lsp.start({
--       name = "change_case_lsp",
--       cmd = { "/home/ben/Documents/my_shit/lsp/dart/change_case_lsp/bin/change_case_lsp.exe" },
--       root_dir = vim.fs.dirname(args.file),
--       })
--     end
--   end,
-- })
