require "pl" -- penlight library (for stringio)

local kconfig = require "kconfig"
local kload = kconfig.load

local test_config = [[
LUA_HAVE_DOT_CONFIG=y
LUA_INTERPRETER="/usr/bin/lua"
LUA_BOOL_TRUE=y
# LUA_BOOL_FALSE is not set
LUA_INT=42
LUA_HEX=0x42
LUA_STRING="Lua test string with quotes: \", '"
]]

describe("#load #prefix", function()

           local t = {}
           local prefix = "lua"

           setup(function()
               t = kload(stringio.open(test_config), prefix)
           end)

           teardown(function()
               t = nil
           end)

           it("return type of load(<stringio>, prefix) is table", function()
                local sio = stringio.open(test_config)
                assert.are.equal(type(kload(sio, prefix)), "table")
                sio = nil
           end)

           it("\"VAR is not set\" defines name", function()
                assert.are.equal("boolean", type(t.bool_false))
           end)
           it("\"VAR is not set\" returns false", function()
                assert.is_false(t.bool_false)
           end)

           it("\"VAR=y\" returns boolean", function()
                assert.are.equal("boolean", type(t.bool_true))
           end)
           it("\"VAR=y\" returns true", function()
                assert.is_true(t.bool_true)
           end)

           it("\"VAR=42\" returns number", function()
                assert.are.equal("number", type(t.int))
           end)
           it("\"VAR=42\" returns 42", function()
                assert.are.equal(42, t.int)
           end)

           it("\"VAR=0x42\" returns number", function()
                assert.are.equal("number", type(t.hex))
           end)
           it("\"VAR=0x42\" returns 66 (0x42)", function()
                assert.are.equal(0x42, t.hex)
           end)

           it("\"VAR=<string>\" returns string", function()
                assert.are.equal("string", type(t.string))
           end)
           it("\"VAR=<string>\" returns <string>", function()
                local test_string = [[Lua test string with quotes: ", ']]
                assert.are.equal(test_string, t.string)
           end)
end)

describe("#load #prefix #no_match", function()

           local t = {}
           local prefix = "lll"

           setup(function()
               t = kload(stringio.open(test_config), prefix)
           end)

           teardown(function()
               t = nil
           end)

           it("return type of load(<stringio>, wrong_prefix) is table", function()
                local sio = stringio.open(test_config)
                assert.are.equal(type(kload(sio, prefix)), "table")
                sio = nil
           end)

           it("Non-matching prefix results in an empty table", function()
                local cnt = 0
                for k,v in pairs(t) do cnt = cnt + 1 end
                assert.are.equal(0, cnt)
                assert.are.equal(0, #t)
           end)
end)
