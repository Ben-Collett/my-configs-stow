--WARN AI
local uv = vim.loop

local M = {}

M.client = nil
M.connected = false
M.connecting = false
M.last_attempt = 0
M.RETRY_INTERVAL = 1.0 -- seconds

local function log_once(msg)
  if not M._logged then
    M._logged = true
    vim.schedule(function()
      vim.notify(msg, vim.log.levels.WARN)
    end)
  end
end

function M.ensure_connected()
  if M.connected or M.connecting then
    return
  end

  local now = uv.now() / 1000
  if now - M.last_attempt < M.RETRY_INTERVAL then
    return
  end

  M.last_attempt = now
  M.connecting = true

  M.client = uv.new_tcp()

  M.client:connect("127.0.0.1", 8765, function(err)
    M.connecting = false

    if err then
      -- log_once("IPC server not running")
      pcall(function()
        M.client:close()
      end)
      M.client = nil
      M.connected = false
      return
    end

    M.connected = true
    M._logged = false

    -- Detect server death
    M.client:read_start(function(read_err, _)
      if read_err then
        M.connected = false
        pcall(function()
          M.client:close()
        end)
        M.client = nil
      end
    end)
  end)
end

function M.send_clear_buffer()
  M.ensure_connected()

  if not M.connected or not M.client then
    return
  end

  local ok = pcall(function()
    M.client:write("c\n")
  end)

  if not ok then
    M.connected = false
    pcall(function()
      M.client:close()
    end)
    M.client = nil
  end
end
return M
