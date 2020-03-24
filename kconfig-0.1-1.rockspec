rockspec_format = "3.0"
package = "kconfig"
version = "0.1-1"
source = {
   url = "https://github.com/ak-fau/lua-kconfig/",
   tag = "v0.1"
}

description = {
   summary  = "A module to read/write kconfig files.",
   license  = "MIT",
   detailed = [[
     This module provides functions to load a configuration file in
     kconfig format into a flat or hierarchical Lua table, optionally
     filtering only variables with a common prefix (and removing the
     prefix).  Resulting table has a metatable preserving order and
     type of variables in the original configuraiton file and a
     function to convert back to a string.  A table may be freely
     converted betwen flat (default) and hierarchical forms.
   ]]
}

build = {
  type = "builtin",
  modules = {
    kconfig = "src/kconfig.lua"
  },
  copy_directories = { "spec" },
}

test = {
  type = "busted",
}

test_dependencies = {
  "penlight", -- for string IO
}
