--
-- Lua interface to .config-format files created by Linux kernel
-- configuration scripts
--

local M = {}
local match = string.match
local lower = string.lower
local gsub = string.gsub

function M.load(f)

  if type(f) == "string" then
    f, err = io.open(f, "r")
    if not f then
      return false, err
    end
  end

  local t = {}

  for l in f:lines() do
    local name, str = match(l, "^([%w+_?]+)=\"(.+)\"$")
    if name and str then
      name = lower(name)
      str = gsub(str, '\\"', '"')
      t[name] = str
    else
      local name = match(l, "^# ([%w+_?]+) is not set$")
      if name then
        name = lower(name)
        t[name] = false
      else
        local name, value = match(l, "^([%w+_?]+)=(.+)$")
        if name and value then
          name = lower(name)
          value = lower(value)
          if value == 'y' then value = true end
          local v = tonumber(value)
          if v then value = v end
          t[name] = value
        end
      end
    end
  end

  return t
end

return M
