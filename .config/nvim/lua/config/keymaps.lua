-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.g.mapleader=' ' --also set in lazy plugin but doesnt seem to work for some reason 

vim.keymap.set("i", "JK", "<ESC>")
vim.keymap.set("i", "KJ", "<ESC>v")
vim.keymap.set("i","FD",'<ESC>"+pa')
vim.keymap.set("i","DF",'<ESC>pa')

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>e", '<cmd>w<cr><cmd>Yazi<cr>')
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")

vim.keymap.set("n", "<leader>p", '"+p')
vim.keymap.set({"n", "v"}, "<leader>y", '"+y')
vim.keymap.set({"n", "v"}, "<leader>Y", '"+Y')

vim.keymap.set({"n", "v"}, "<leader>d", '"_d')
vim.keymap.set({"n", "v"}, "<leader>D", '"_D')

vim.keymap.set("n","<leader>sa", "gg0vG$")
