local M = {}

function M.replace_under_cursor()
  -- get word under cursor
  local word = vim.fn.expand("<cword>")

  -- prompt for replacement
  local replacement = vim.fn.input("Replace '" .. word .. "' with: ")

  -- do the substitution with confirmation
  if replacement ~= "" then
    local cmd = string.format("%%s/\\<%s\\>/%s/gc", word, replacement)
    vim.cmd(cmd)
  end
end

return M
