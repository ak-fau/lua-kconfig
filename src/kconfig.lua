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
local format = string.format

local concat = table.concat

local function string_escape(s)
  return '"' .. gsub(s, '"', '\\"') .. '"'
end

local function kv2string(k, v, h, p)
  local kl = k

  if p and p ~= "" then
    p = upper(p) .. "_"
  end

  p = p or ""
  k = p .. upper(kl)

  if type(v) == "string" then
    return k .. "=" ..  string_escape(v)
  elseif type(v) == "boolean" then
    if v then
      return k .. "=y"
    else
      return "# " .. k .. " is not set"
    end
  elseif type(v) == "number" then
    if h[kl] then
      return k .. "=" .. format("0x%x", v)
    else
      return k .. "=" .. tostring(v)
    end
  else
    error("Lua kconfig: variable: '" .. kl .. "' of unsupported type: " .. type(v))
  end
end

local function config2string(t)

  local s = {}
  local mt = getmetatable(t) or {}
  local _hex = mt._hex or {}
  local _ord = mt._ord
  local _prefix = mt._prefix

  if _ord then
    for _, k in ipairs(_ord) do
      s[#s+1] = kv2string(k, t[k], _hex, _prefix)
    end
  else
    for k, v in pairs(t) do
      s[#s+1] = kv2string(k, v, _hex, _prefix)
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
  local o = {}
  local mt =  {__tostring = config2string,
               _hex = {},
               _ord = o,
               _prefix = prefix}
  setmetatable(t, mt)

  for l in f:lines() do
    local name, str = match(l, "^([%w+_?]+)=\"(.+)\"$")
    if name and str then
      name = lower(name)
      if match(name, prefix_pattern) then
        name = gsub(name, prefix_pattern, "")
        str = gsub(str, '\\"', '"')
        t[name] = str
        o[#o+1] = name
      end
    else
      local name = match(l, "^# ([%w+_?]+) is not set$")
      if name then
        name = lower(name)
        if match(name, prefix_pattern) then
          name = gsub(name, prefix_pattern, "")
          t[name] = false
          o[#o+1] = name
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
            if v then
              if match(value, "^0x") then
                mt._hex[name] = true
              end
              value = v
            end
            t[name] = value
            o[#o+1] = name
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
