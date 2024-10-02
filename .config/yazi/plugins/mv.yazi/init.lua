local get_selected = ya.sync(function()
  local paths = {}
  -- get selected files
  for _, u in pairs(cx.active.selected) do
    paths[#paths + 1] = tostring(u)
  end
  return paths
end)

local get_current_working_directory = ya.sync(function()
  return tostring(cx.active.current.cwd)
end)

local function move()
end
local function collision(files, current_dir)
end
local function moveInc()
end
local function moveReplace()
end
local function moveIgnore()
end
local function moveFile(file, dir)
end
local function extractName(file)
  return file:match("([^/\\]+)$") or '/'
end

local prompt = ya.sync(
function()
end)


return {
  entry = function()
    local items = get_selected()
    local working_dir = get_current_working_directory();
    ya.notify({title = "ehll", content = extractName(working_dir),level = "warn", timeout=4})

  end,
}
