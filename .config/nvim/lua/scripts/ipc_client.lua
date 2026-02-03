--WARNING AI
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

function M.send_message(msg)
  M.ensure_connected()

  if not M.connected or not M.client then
    return
  end

  local ok = pcall(function()
    M.client:write(msg:len() .. "\n" .. msg)
  end)

  if not ok then
    M.connected = false
    pcall(function()
      M.client:close()
    end)
    M.client = nil
  end
end
function M.normal_casing()
  M.send_message("mc")
end

function M.snake_casing()
  M.send_message("sc")
end
function M.proper_casing()
  M.send_message("pm")
end
function M.camel_casing()
  M.send_message("cm")
end
function M.upper_snake_casing()
  M.send("us")
end

function M.reload_config()
  M.send("rl")
end
function M.restart()
  M.send("rs")
end

function M.send_clear_buffer()
  M.send_message("cb")
end
function M.set_main_buffer(text)
  M.send_message("sm " .. text)
end
function M.set_right_buffer(text)
  M.send_message("sr " .. text)
end

return M
