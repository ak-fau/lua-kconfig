require "pl" -- penlight library (for stringio)

local kconfig = require "kconfig"
local kload = kconfig.load

local function test_string()
  local s = [[LUA_STRING="Lua test string with quotes: \", '"
]]
  local t = kload(stringio.open(s))
  assert.is_equal(s, tostring(t))
end

local function test_full()
  local test_config = [[
LUA_HAVE_DOT_CONFIG=y
LUA_INTERPRETER="/usr/bin/lua"
LUA_BOOL_TRUE=y
# LUA_BOOL_FALSE is not set
LUA_INT=42
LUA_HEX=0x42
LUA_STRING="Lua test string with quotes: \", '"
]]

  local t = kload(stringio.open(test_config))
  assert.is_equal(test_config, tostring(t))
end

describe("#tostring", function()
           it("#string", test_string)
           it("#full config with all types", test_full)
end)
