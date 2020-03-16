--
-- Lua interface to .config-format files created by Linux kernel
-- configuration scripts
--

local M = {}

local match = string.match
local lower = string.lower
local upper = string.upper
local gsub = string.gsub
local gmatch = string.gmatch

local concat = table.concat

local function string_escape(s)
  return '"' .. gsub(s, '"', '\\"') .. '"'
end

local function config2string(t)
  local s = {}
  for k, v in pairs(t) do
    k = upper(k)
    if type(v) == "string" then
      s[#s+1] = k .. "=" ..  string_escape(v)
    elseif type(v) == "boolean" then
      if v then
        s[#s+1] = k .. "=y"
      else
        s[#s+1] = "# " .. k .. " is not set"
      end
    else
      s[#s+1] = k .. "=" .. tostring(v)
    end
  end
  s[#s+1] = "" -- to have EOL after the last line
  return concat(s, "\n")
end

function M.load(f, prefix)

  prefix = prefix and lower(prefix) or ""
  local prefix_pattern = "^" .. prefix .. "_*"

  if type(f) == "string" then
    f, err = io.open(f, "r")
    if not f then
      return false, err
    end
  end

  local t = {}
  setmetatable(t, {__tostring = config2string,
                   _hex = {},
                   _prefix = prefix})

  for l in f:lines() do
    local name, str = match(l, "^([%w+_?]+)=\"(.+)\"$")
    if name and str then
      name = lower(name)
      if match(name, prefix_pattern) then
        name = gsub(name, prefix_pattern, "")
        str = gsub(str, '\\"', '"')
        t[name] = str
      end
    else
      local name = match(l, "^# ([%w+_?]+) is not set$")
      if name then
        name = lower(name)
        if match(name, prefix_pattern) then
          name = gsub(name, prefix_pattern, "")
          t[name] = false
        end
      else
        local name, value = match(l, "^([%w+_?]+)=(.+)$")
        if name and value then
          name = lower(name)
          if match(name, prefix_pattern) then
            name = gsub(name, prefix_pattern, "")
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
