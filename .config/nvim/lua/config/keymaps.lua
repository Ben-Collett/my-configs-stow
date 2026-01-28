-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- gx lets you follow a url appareantly
-- Add any additional keymaps here
vim.g.mapleader = " " --also set in lazy plugin but doesnt seem to work for some reason
-- vim.keymap.set("i", "FD", '<ESC>"+pa')
-- vim.keymap.set("i", "DF", "<ESC>pa")
vim.keymap.set("i", "<C-H>", "<ESC>dbxi")
vim.keymap.set({ "n", "i" }, "<C-A>", "<ESC>caw")
vim.api.nvim_set_keymap("n", "'a", "`a", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "`a", "'a", { noremap = true, silent = true })

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

vim.keymap.set("t", "<C-;>", [[<C-\><C-n>]])
vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<cr>")

vim.api.nvim_set_keymap(
  "n",
  "<leader>xe",
  "<cmd>Trouble diagnostics filter.severity=vim.diagnostic.severity.ERROR<cr>",
  { noremap = true, silent = true }
)
