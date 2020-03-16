require "pl" -- penlight library (for stringio)

local kconfig = require "kconfig"
local kload = kconfig.load
local hierarchy = kconfig.hierarchy

local test_x

local function test_string()
  test_x [[LUA_STRING="Lua test string with quotes: \", '"
]]
end

local function test_bool_true()
  test_x [[LUA_BOOL_TRUE=y
]]
end

local function test_bool_false()
  test_x [[# LUA_BOOL_FALSE is not set
]]
end

local function test_integer()
  test_x [[LUA_INT=42
]]
end

local function test_hex()
  test_x [[LUA_HEX=0x42
]]
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

           setup(function()
               test_x = function(s)
                 local t = kload(stringio.open(s))
                 assert.is_equal(s, tostring(t))
               end
           end)

           it("#string", test_string)
           it("#boolean #true", test_bool_true)
           it("#boolean #false", test_bool_false)
           it("#int", test_integer)
           it("#hex", test_hex)
           it("#full config with all types", test_full)
end)

describe("#tostring #hierarchy", function()

           setup(function()
               test_x = function(s)
                 local t = kload(stringio.open(s))
                 t = hierarchy(t)
                 assert.is_equal(s, tostring(t))
               end
           end)

           it("#string", test_string)
           it("#boolean #true", test_bool_true)
           it("#boolean #false", test_bool_false)
           it("#int", test_integer)
           it("#hex", test_hex)
           it("#full config with all types", test_full)
end)

describe("#tostring #prefix", function()
           local prefix = "lua"

           setup(function()
               test_x = function(s)
                 local t = kload(stringio.open(s), prefix)
                 assert.is_equal(s, tostring(t))
               end
           end)

           it("#string #debug", test_string)
           it("#boolean #true", test_bool_true)
           it("#boolean #false", test_bool_false)
           it("#int", test_integer)
           it("#hex", test_hex)
           it("#full config with all types", test_full)
end)

describe("#tostring #hierarchy #prefix", function()
           local prefix = "lua"

           setup(function()
               test_x = function(s)
                 local t = kload(stringio.open(s), prefix)
                 t = hierarchy(t)
                 assert.is_equal(s, tostring(t))
               end
           end)

           it("#string", test_string)
           it("#boolean #true", test_bool_true)
           it("#boolean #false", test_bool_false)
           it("#int", test_integer)
           it("#hex", test_hex)
           it("#full config with all types", test_full)
end)
