require "pl" -- penlight library (for stringio)

local kconfig = require "kconfig"
local kload = kconfig.load
local hierarchy = kconfig.hierarchy

local test_config = [[
LUA_HAVE_DOT_CONFIG=y
LUA_INTERPRETER="/usr/bin/lua"
LUA_BOOL_TRUE=y
# LUA_BOOL_FALSE is not set
LUA_INT=42
LUA_HEX=0x42
LUA_STRING="Lua test string with quotes: \", '"
]]

describe("#hierarchy:", function()

           local t = {}

           setup(function()
               t = kload(stringio.open(test_config))
               t = hierarchy(t)
           end)

           teardown(function()
               t = nil
           end)

           it("Return type of hierarchy() is table", function()
                assert.is_equal("table", type(t))
           end)

           it("An element 'lua' on top level is a table", function()
                assert.is_equal("table", type(t.lua))
           end)

           it("Second level #string", function()
                assert.is_equal("table", type(t.lua))
                assert.is_equal("Lua test string with quotes: \", '", t.lua.string)
           end)

           it("Second level #int", function()
                assert.is_equal("table", type(t.lua))
                assert.is_equal(42, t.lua.int)
           end)

           it("Second level #hex", function()
                assert.is_equal("table", type(t.lua))
                assert.is_equal(0x42, t.lua.hex)
           end)

end)

describe("Incorrect #hierarchy:", function()

           it("Expected #error with {a=1, a_b=2}", function()
                t = kload(stringio.open([[
A=1
A_B=2
]]))
                assert.has.errors(function() hierarchy(t) end)
           end)

end)
