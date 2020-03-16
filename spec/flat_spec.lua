require "pl" -- penlight library (for stringio)

local kconfig = require "kconfig"
local kload = kconfig.load
local hierarchy = kconfig.hierarchy
local flat = kconfig.flat

local test_config = [[
LUA_HAVE_DOT_CONFIG=y
LUA_INTERPRETER="/usr/bin/lua"
LUA_BOOL_TRUE=y
# LUA_BOOL_FALSE is not set
LUA_INT=42
LUA_HEX=0x42
LUA_STRING="Lua test string with quotes: \", '"
]]

describe("#flat:", function()

           local t = {}
           local h = {}
           local f = {}

           setup(function()
               t = kload(stringio.open(test_config))
               h = hierarchy(t)
               f = flat(h)
           end)

           teardown(function()
               t = nil
           end)

           it("Return type of flat() is table", function()
                assert.is_equal("table", type(f))
           end)

           it("Metatable is preserved through the flat(hierarchy(t)) conversion", function()
                assert.are_same(getmetatable(t), getmetatable(f))
           end)

           it("t == flat(hierarchy(t))", function()
                assert.are_same(t, f)
           end)
end)
