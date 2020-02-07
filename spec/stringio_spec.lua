
require "pl" -- penlight library

local kconfig = require "kconfig"

local test_config = [[
LUA_HAVE_DOT_CONFIG=y
LUA_INTERPRETER="/usr/bin/lua"
LUA_BOOL_TRUE=y
# LUA_BOOL_FALSE is not set
LUA_INT=42
LUA_HEX=0x42
LUA_STRING="Lua test string with quotes: \", '"
]]

local test_string = [[Lua test string with quotes: ", ']]

describe("#load", function()
           it("return type of load(<stringio>) is table", function()
                local sio = stringio.open(test_config)
                assert.are.equal(type(kconfig.load(sio)), "table")
           end)
end)
