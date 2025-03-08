-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- gx lets you follow a url appareantly
-- Add any additional keymaps here
vim.g.mapleader = " " --also set in lazy plugin but doesnt seem to work for some reason
vim.keymap.set("i", "FD", '<ESC>"+pa')
vim.keymap.set("i", "DF", "<ESC>pa")
vim.keymap.set("i", "<C-H>", "<ESC>dbxi")
vim.keymap.set({ "n", "i" }, "<C-A>", "<ESC>caw")

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>e", "<cmd>w<cr><cmd>Yazi<cr>")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set({ "n", "v", "i" }, "<C-P>", '"+p')
vim.keymap.set("n", "P", '"+p')
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>Y", '"+Y')

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')
vim.keymap.set({ "n", "v" }, "<leader>D", '"_D')
vim.keymap.set({ "n" }, "<leader>lc", "<cmd>w<cr><cmd>colorscheme mytheme<cr>")
vim.keymap.set("n", "<leader>sa", "gg0vG$")

vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

local vim = vim
local api = vim.api
local M = {}
-- function to create a list of commands and convert them to autocommands
-------- This function is taken from https://github.com/norcalli/nvim_utils
function M.nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    api.nvim_command("augroup " .. group_name)
    api.nvim_command("autocmd!")
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
      api.nvim_command(command)
    end
    api.nvim_command("augroup END")
  end
end

local autoCommands = {
  -- other autocommands
  open_folds = {
    { "BufReadPost,FileReadPost", "*", "normal zR" },
  },
}

M.nvim_create_augroups(autoCommands)
-- Toggle fold under cursor
vim.api.nvim_set_keymap(
  "n",
  "<leader>fm",
  ':lua require"nvim-treesitter.fold".toggle()<CR>',
  { noremap = true, silent = true }
)

-- Fold all methods in the file
vim.api.nvim_set_keymap(
  "n",
  "<leader>fa",
  ':lua vim.wo.foldmethod="expr"; vim.wo.foldexpr="nvim_treesitter#foldexpr()"<CR>',
  { noremap = true, silent = true }
)

-- Unfold all methods in the file
vim.api.nvim_set_keymap(
  "n",
  "<leader>ua",
  ':lua vim.wo.foldmethod="manual"; vim.wo.foldlevel=99<CR>',
  { noremap = true, silent = true }
)
