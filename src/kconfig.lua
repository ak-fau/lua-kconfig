--
-- Lua interface to .config-format files created by Linux kernel
-- configuration scripts
--

local M = {}
local match = string.match
local lower = string.lower
local gsub = string.gsub
local gmatch = string.gmatch

function M.load(f, prefix)

  prefix = prefix and "^" .. lower(prefix) .. "_*" or ""

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
      if match(name, prefix) then
        name = gsub(name, prefix, "")
        str = gsub(str, '\\"', '"')
        t[name] = str
      end
    else
      local name = match(l, "^# ([%w+_?]+) is not set$")
      if name then
        name = lower(name)
        if match(name, prefix) then
          name = gsub(name, prefix, "")
          t[name] = false
        end
      else
        local name, value = match(l, "^([%w+_?]+)=(.+)$")
        if name and value then
          name = lower(name)
          if match(name, prefix) then
            name = gsub(name, prefix, "")
            value = lower(value)
            if value == 'y' then value = true end
            local v = tonumber(value)
            if v then value = v end
            t[name] = value
          end
        end
      end
    end
  end

  return t
end

function M.hierarchy(t)
  local h = {}

  for k, v in pairs(t) do
    local e = h
    local path = {}

    for name in gmatch(k .. "_", "(.-)_") do
      path[#path + 1] = name
    end

    for i, name in ipairs(path) do
      if i == #path then
        if type(e[path[i]]) == "nil" then
          e[path[i]] = v
        else
          error("Cannot convert to hierarchical path: " .. k .. ", at step " .. i)
        end
      else
        if type(e[path[i]]) == "nil" then
          e[path[i]] = {}
          e = e[path[i]]
        elseif type(e[path[i]]) == "table" then
          e = e[path[i]]
        else
          error("Cannot convert to hierarchical path: " .. k .. ", at step " .. i)
        end
      end
    end

  end

  return h
end

return M
