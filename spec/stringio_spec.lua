require "pl" -- penlight library (for stringio)

local kconfig = require "kconfig"
local kload = kconfig.load

local load_tests = require "spec/load_tests"

local test_config = [[
LUA_HAVE_DOT_CONFIG=y
LUA_INTERPRETER="/usr/bin/lua"
LUA_BOOL_TRUE=y
# LUA_BOOL_FALSE is not set
LUA_INT=42
LUA_HEX=0x42
LUA_STRING="Lua test string with quotes: \", '"
]]

describe("#load #stringio", function()

           local t = {}

           setup(function()
               t = kload(stringio.open(test_config))
           end)

           teardown(function()
               t = nil
           end)

           it("return type of load(<stringio>) is table", function()
                local sio = stringio.open(test_config)
                assert.are.equal(type(kload(sio)), "table")
                sio = nil
           end)

           describe("#types", function()
                      load_tests(t)
           end)

end)
