return {
  "mbbill/undotree",
  config = function()
    local cmd = "<cmd>UndotreeToggle<cr>"
    vim.keymap.set("n", "<leader>ut", cmd)
  end,
}
