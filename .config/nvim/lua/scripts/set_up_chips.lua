local ts_utils = require("nvim-treesitter.ts_utils")

local function get_left_right_buffers()
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  -- Lua strings are 1-based
  local left = line:sub(1, col)
  local right = line:sub(col + 1)

  return left, right
end

local function in_string_or_comment()
  local node = ts_utils.get_node_at_cursor()
  while node do
    local t = node:type()
    if t:match("string") or t:match("comment") then
      return true
    end
    node = node:parent()
  end
  return false
end

local function words_left_of_cursor()
  local left, _ = get_left_right_buffers()

  -- strip trailing whitespace
  left = left:gsub("%s+$", "")

  -- split into words
  local words = {}
  for w in left:gmatch("[%a_][%w_]*") do
    table.insert(words, w)
  end
  return words
end

local function should_use_snake_case()
  if in_string_or_comment() then
    return false
  end

  local words = words_left_of_cursor()

  -- scan backwards
  for i = #words, 1, -1 do
    if words[i] == "def" then
      -- at least one word after def
      return (#words - i) >= 1
    end
  end

  return false
end
vim.on_key(function()
  local mode = vim.api.nvim_get_mode().mode
  local m = mode:sub(1, 1)

  if m == "i" or m == "c" or m == "t" then
    return
  end

  require("scripts.ipc_client").send_clear_buffer()
end, vim.api.nvim_create_namespace("ipc_cb"))

local ipc = require("scripts.ipc_client")

local function update_buffers()
  local left, right = get_left_right_buffers()
  ipc.set_main_buffer(left)
  ipc.set_right_buffer(right)
end

local group = vim.api.nvim_create_augroup("IPCInsertTracking", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
  group = group,
  callback = update_buffers,
})

vim.api.nvim_create_autocmd("CursorMovedI", {
  group = group,
  callback = update_buffers,
})
