local kconfig = require "kconfig"
local kload = kconfig.load

local test_file_name = "spec/test_config"
local load_tests = require "spec/load_tests"

describe("#load #file", function()

           local t = {}

           setup(function()
               t = kload(test_file_name)
           end)

           teardown(function()
               t = nil
           end)

           it("return type of load(<file>) is table", function()
                local f = io.open(test_file_name)
                assert.are.equal(type(kload(f)), "table")
                f:close()
           end)

           it("return type of load(<filename>) is table", function()
                assert.are.equal(type(kload(test_file_name)), "table")
           end)

           describe("#types", function()
                      load_tests(t)
           end)

end)
