-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- gx lets you follow a url appareantly
-- Add any additional keymaps here
vim.g.mapleader = " " --also set in lazy plugin but doesnt seem to work for some reason
vim.keymap.set("i", "FD", '<ESC>"+pa')
vim.keymap.set("i", "DF", "<ESC>pa")
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

--TODO: find in pubsec.yaml using grep
local function is_flutter_project()
  return true
end
local function run()
  local filetype = vim.bo.filetype
  local file_path = vim.fn.expand("%:p")
  if is_flutter_project() and filetype == "dart" then
    --WARNING: this depends on toggle term, or at the very least a TermExec command that works like toggle term
    vim.cmd('TermExec cmd="flutter run -t ' .. file_path .. '"')
  elseif filetype == "python" then
    vim.cmd('TermExec cmd="python ' .. file_path .. '"')
  end
end

vim.keymap.set("n", "<leader>ru", run)

local function get_selected()
  if vim.fn.mode() ~= "v" then
    print("Not in visual mode!")
    return
  end

  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  return vim.fn.getline(start_pos[2], end_pos[2])
end

local function create_window_with_text(text)
  -- Create a new buffer (scratch buffer)
  local buf = vim.api.nvim_create_buf(false, true)

  -- Get the current editor size
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

  -- Define window size and position
  local win_width = math.ceil(width * 0.5)
  local win_height = math.ceil(height * 0.3)
  local row = math.ceil((height - win_height) / 2)
  local col = math.ceil((width - win_width) / 2)

  -- Create a floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = "minimal",
    border = "single",
  })

  -- Set the buffer text
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { text })
end

-- Example usage
local function wrap_with_if()
  -- Get the start and end position of the selection
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  -- Get the text within the selected range
  local lines = get_selected()
  if lines == nil then
    return
  end

  create_window_with_text(lines)
  -- Determine the indentation level of the first line
  local indent_level = string.match(lines[1], "^%s*")

  -- Wrap the content with the if statement and indent the content
  local wrapped_lines = {}
  table.insert(wrapped_lines, indent_level .. "if () {")

  for _, line in ipairs(lines) do
    -- Indent each line with one level
    table.insert(wrapped_lines, indent_level .. "  " .. line)
  end

  table.insert(wrapped_lines, indent_level .. "}")

  -- Replace the selected content with the wrapped lines
  vim.fn.setline(start_pos[2], wrapped_lines[1])

  -- For subsequent lines, replace them while keeping the indent
  for i = 2, #wrapped_lines do
    vim.fn.append(start_pos[2] + i - 1, wrapped_lines[i])
  end

  -- Adjust the cursor position to the end of the wrapped block
  vim.fn.setpos(".", { 0, end_pos[2] + #wrapped_lines - 1, 0, 0 })

  -- Optionally: clear the selection after wrapping
  vim.cmd("normal! gv")
end

-- Bind the function to a key in normal mode (e.g., <Leader>w)
