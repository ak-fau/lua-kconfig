local kconfig = require "kconfig"
local tts = kconfig.tostring

describe("Table-to-string (#tts)", function()

           it("return type of tostring(t) is string", function()
                assert.are.equal(type(tts {}), "string")
           end)

           it("tostring() for empty table returns empty string", function()
                assert.are.equal(string.len(tts {}), 0)
           end)

           describe("#boolean", function()
                      it("#true", function()
                           assert.are.equal(tts {lua_boolean_true = true}, "LUA_BOOLEAN_TRUE=y\n")
                      end)
                      it("#false", function()
                           assert.are.equal(tts {lua_boolean_false = false}, "# LUA_BOOLEAN_FALSE is not set\n")
                      end)
           end)

           it("#int", function()
                assert.are.equal(tts {lua_integer = 42}, "LUA_INTEGER=42\n")
           end)

           it("#string", function()
                assert.are.equal(tts {lua_string = [[Lua test string with quotes: ", ']]},
                                 "LUA_STRING=\"Lua test string with quotes: \\\", '\"\n")
           end)

end)
