local busted = require "busted"
local it = busted.it
local assert = busted.assert

return function(t)
           it("\"VAR is not set\" defines name", function()
                assert.are.equal("boolean", type(t.lua_bool_false))
           end)
           it("\"VAR is not set\" returns false", function()
                assert.is_false(t.lua_bool_false)
           end)

           it("\"VAR=y\" returns boolean", function()
                assert.are.equal("boolean", type(t.lua_bool_true))
           end)
           it("\"VAR=y\" returns true", function()
                assert.is_true(t.lua_bool_true)
           end)

           it("\"VAR=42\" returns number", function()
                assert.are.equal("number", type(t.lua_int))
           end)
           it("\"VAR=42\" returns 42", function()
                assert.are.equal(42, t.lua_int)
           end)

           it("\"VAR=0x42\" returns number", function()
                assert.are.equal("number", type(t.lua_hex))
           end)
           it("\"VAR=0x42\" returns 66 (0x42)", function()
                assert.are.equal(0x42, t.lua_hex)
           end)

           it("\"VAR=<string>\" returns string", function()
                assert.are.equal("string", type(t.lua_string))
           end)
           it("\"VAR=<string>\" returns <string>", function()
                local test_string = [[Lua test string with quotes: ", ']]
                assert.are.equal(test_string, t.lua_string)
           end)
end
